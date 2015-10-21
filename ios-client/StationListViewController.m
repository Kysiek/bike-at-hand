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
@end

@implementation StationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
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
    [self getUserLocationAndSortCells];
}
- (void) receivedNotification:(NSNotification *) notification {
    
    if ([[notification name] isEqualToString:StationsArrivalNotification]) {
        [self reloadTableViewForStations:[self.stationService getStationsArray]];
    } else if([[notification name] isEqualToString:StationsErrorNotification]) {
        //TODO: On error
    } else if([[notification name] isEqualToString:LocationArrivalNotification]) {
        [self getUserLocationAndSortCells];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) dealloc {
    //Removing observer - we need to do it otherwise there will be exception when property would be changed and this instance would not exist
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"stationDetailsSegue"]) {
        StationDetailsViewController* stationDetailVC = [segue destinationViewController];
        stationDetailVC.delegate = self;
        Station* station = nil;
        StationListTableViewCell* cell = sender;
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        station = self.stations[indexPath.row];
        stationDetailVC.station = station;
    }
}


-(void) reloadTableViewForStations: (NSArray*) stations{
    self.stations = stations;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark - Station details delegate methods
-(void) didTabExitButtonInStationDetailsController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - Search bar delegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText && ![searchText isEqualToString:@""]) {
        self.limitedStationsArray = [self getStationsForSearchPhrase:searchText];
    } else {
        self.limitedStationsArray = nil;
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.limitedStationsArray = nil;
    [self.tableView reloadData];
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
    cell.backgroundColor = [UIColor whiteColor];
    [cell setLabels:station];
    if([station hasAvailableBikes]) {
        
    } else {
        
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
- (NSArray*) getStationsForSearchPhrase:(NSString*) searchPhrase {
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    for(Station *station in self.stations) {
        if([station.stationName containsString:searchPhrase]) {
            [resultArray addObject:station];
        }
    }
    return resultArray;
}

- (void)sortStations:(CLLocation*)userLocation {
    for (Station *station in self.stations) {
        
        CLLocationDegrees latitude = [station.latitude doubleValue];
        CLLocationDegrees longitude = [station.longitude doubleValue];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        CLLocationDistance distance = [userLocation distanceFromLocation:location];
        //Storing as string since latitude and longitude is also string values
        //Since its a dictionary storing as NSNumber is better
        station.distance = [NSNumber numberWithDouble:distance];
    }
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                               ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
    self.stations = [self.stations sortedArrayUsingDescriptors:sortDescriptors];
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
