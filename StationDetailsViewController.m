//
//  StationDetailsViewController.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 10/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "StationDetailsViewController.h"
#import "BikeTableViewCell.h"

@interface StationDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bikesAvailableLabel;

@end

@implementation StationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stationNameLabel.text = self.station.stationName;
    self.bikesAvailableLabel.text = [NSString stringWithFormat:@"Dostępne rowery: %@",self.station.bikesAvailable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View delegate methods
static NSString* CellID = @"bikeCustomCell";

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    BikeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setData:self.station.bikes[row]];
    return cell;
}
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.station.bikes.count;
}

@end
