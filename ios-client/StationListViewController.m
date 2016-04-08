//
//  StationListViewController.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 18/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "StationListViewController.h"
#import "StationListTableViewCell.h"
#import "LocationService.h"
#import "StationService.h"
#import "Station.h"

@interface StationListViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) StationService* stationService;
@property (nonatomic, strong) LocationService* locationService;
@property (nonatomic, strong) NSArray* stations;
@property (nonatomic, strong) NSArray* limitedStationsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) UISearchController* searchController;

@end

@implementation StationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //initializing the refresh controll
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshStationList:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self initializeSearchController];
    self.stationService = [StationService getInstance];
    
    //adding observator to the notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:StationsArrivalNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:StationsErrorNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:LocationArrivalNotification
                                               object:nil];
    
    self.stations = [self.stationService getStationsArray];
    self.locationService = [LocationService getInstance];
    if(self.stations) {
        [self getUserLocationAndSortCells];
    }
    
}
- (void) receivedNotification:(NSNotification *) notification {
    
    if ([[notification name] isEqualToString:StationsArrivalNotification]) {
        if([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        [self getUserLocationAndSortCells];
    } else if([[notification name] isEqualToString:StationsErrorNotification]) {
        //TODO: On error
    } else if([[notification name] isEqualToString:LocationArrivalNotification]) {
        [self getUserLocationAndSortCells];
    }
}
- (void) initializeSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.searchController.searchBar.scopeButtonTitles = @[@"All stations", @"With bikes"];
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = true;
}
-(void) dealloc {
    //Removing observer - we need to do it otherwise there will be exception when property would be changed and this instance would not exist
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"stationDetailsSegue"]) {
        [self.searchBar resignFirstResponder];
        
        StationDetailsViewController* stationDetailVC = [segue destinationViewController];
        stationDetailVC.delegate = self;
        Station* station = nil;
        StationListTableViewCell* cell = sender;
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        if(self.limitedStationsArray) {
            station = self.limitedStationsArray[indexPath.row];
        } else {
            station = self.stations[indexPath.row];
        }
        stationDetailVC.station = station;
        stationDetailVC.hidesBottomBarWhenPushed = YES;
    }
}


-(void) reloadTableViewForStations: (NSArray*) stations{
    self.stations = stations;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void)refreshStationList:(UIRefreshControl *)refreshControl {
    [self.stationService fetchStations];
}

#pragma mark - Station details delegate methods
-(void) didTabExitButtonInStationDetailsController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - Search bar delegate methods

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    if(selectedScope == 1) {
        self.limitedStationsArray = [Station getNotEmptyStations:self.limitedStationsArray];
    } else {
        NSString *searchText = [searchBar text];
        if(searchText && ![searchText isEqualToString:@""]) {
            
            self.limitedStationsArray = [Station getStations:self.stations forSearchPhrase:[searchText lowercaseString]];
        } else {
            self.limitedStationsArray = nil;
        }
    }
    [self.tableView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.limitedStationsArray = nil;
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}
#pragma mark - Search Results Updating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = [self.searchController.searchBar text];
    if(searchText && ![searchText isEqualToString:@""]) {
        self.limitedStationsArray = [Station getStations:self.stations forSearchPhrase:[searchText lowercaseString]];
    } else {
        self.limitedStationsArray = nil;
    }
    [self limitStationsForSelectedScope:[searchController searchBar].selectedScopeButtonIndex];
    [self.tableView reloadData];
}

#pragma mark - TableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}
#pragma mark - Table view data source
static NSString* CellID = @"stationCustomCell";

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    Station* station;
    if(self.limitedStationsArray) {
        station = self.limitedStationsArray[row];
    } else {
        station = self.stations[row];
    }
    StationListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    [cell setLabels:station];
    if([station hasLowAvailability]) {
        [cell markCellWithBikesLowAvailability];
    } else {
        [cell markCellWithBikesHighAvailability];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.limitedStationsArray) {
        return self.limitedStationsArray.count;
    }
    if(self.stations) {
        return self.stations.count;
    }
    return 0;
}

#pragma mark - Private helpers

- (void)sortStations:(CLLocation*)userLocation {
    for (Station *station in self.stations) {
        
        CLLocationDegrees latitude = [station.latitude doubleValue];
        CLLocationDegrees longitude = [station.longitude doubleValue];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        CLLocationDistance distance = [userLocation distanceFromLocation:location];
        station.distance = [NSNumber numberWithDouble:distance];
    }
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                               ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
    self.stations = [self.stations sortedArrayUsingDescriptors:sortDescriptors];
}

- (void) limitStationsForSelectedScope:(NSInteger) selectedScope {
    if(selectedScope == 1) {
        self.limitedStationsArray = [Station getNotEmptyStations:self.limitedStationsArray];
    }
}

- (void)getUserLocationAndSortCells {
    if(self.stations) {
        CLLocation* userLocation = [self.locationService getUserLocation];
        if(userLocation) {
            [self sortStations:userLocation];
            [self reloadTableViewForStations:self.stations];
        }
    }
}

@end
