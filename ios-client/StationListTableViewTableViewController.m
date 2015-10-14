//
//  StationListTableViewTableViewController.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 21/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "StationListTableViewTableViewController.h"
#import "StationListCustomCellTableViewCell.h"
#import "StationService.h"
#import "MapStationViewController.h"
#import "RentBikePopupViewController.h"
#import "LocationService.h"
#import "StationDetailsViewController.h"
#import <MapKit/MapKit.h>

@interface StationListTableViewTableViewController ()
@property (nonatomic, strong) NSArray* stations;
@property (nonatomic, strong) NSArray* limitedStationsArray;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) StationService* stationService;
@property (nonatomic, strong) LocationService* locationService;
@end

@implementation StationListTableViewTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.barButton.title = stationListViewControllerTitle;
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
    
    self.stations = [self.stationService getStationsArray];
    self.locationService = [LocationService getInstance];
    [self getUserLocationAndSortCells];
    
    
    
}
- (void) receivedNotification:(NSNotification *) notification {
    
    if ([[notification name] isEqualToString:StationsArrivalNotification]) {
        [self reloadTableViewForStations:[self.stationService getStationsArray]];
    } else if([[notification name] isEqualToString:StationsErrorNotification]) {
        [self showErrorMessage:[self.stationService getErrorMessage] forViewController:self];
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
-(void) reloadTableViewForStations: (NSArray*) stations{
    self.stations = stations;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(([[segue identifier] isEqualToString:@"presentOnTheMapSegue"])) {
        MapStationViewController* mapStation = [segue destinationViewController];
        [mapStation setStations:self.limitedStationsArray ? self.limitedStationsArray : self.stations];
    } else if(([[segue identifier] isEqualToString:@"stationDetailSegue"])) {
        StationDetailsViewController* stationDetailVC = [segue destinationViewController];
        Station* station = nil;
        StationListCustomCellTableViewCell* cell = sender;
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        if(self.limitedStationsArray) {
            station = self.limitedStationsArray[indexPath.row];
        } else {
            station = self.stations[indexPath.row];
        }
        stationDetailVC.station = station;
//        RentBikePopupViewController* popupVC = [segue destinationViewController];
//        popupVC.popoverPresentationController.delegate = self;
//        
//        popupVC.preferredContentSize = CGSizeMake(300, 500);
    }
}
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
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

#pragma mark - Table View delegate methods
static NSString* CellID = @"stationCustomCell";

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    Station* station;
    if(self.limitedStationsArray) {
        station = self.limitedStationsArray[row];
    } else {
        station = self.stations[row];
    }
    StationListCustomCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellID];
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
