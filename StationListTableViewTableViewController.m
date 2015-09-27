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

@interface StationListTableViewTableViewController ()
@property (nonatomic, strong) NSArray* stations;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) StationService* stationService;
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

static NSString* CellID = @"stationCustomCell";

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    Station* station = self.stations[row];
    StationListCustomCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setLabels:station];
    return cell;
}
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.stations) {
        return self.stations.count;
    }
    return 0;
}

@end
