//
//  StationListTableViewCell.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 18/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "StationListTableViewCell.h"

@interface StationListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bikesAvailableLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
@implementation StationListTableViewCell
- (void)setLabels:(Station *)station {
    self.stationNameLabel.text = station.stationName;
    self.bikesAvailableLabel.text = [NSString stringWithFormat:@"Dostępne rowery: %ld", (long)[station getBikesAvailable]];
    self.distanceLabel.text = [station prettifyDistance];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
