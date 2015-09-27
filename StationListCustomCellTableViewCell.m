//
//  StationListCustomCellTableViewCell.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 21/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "StationListCustomCellTableViewCell.h"

@interface StationListCustomCellTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bikesAvailableLabel;

@end
@implementation StationListCustomCellTableViewCell

- (void) setLabels:(Station *)station {
    self.stationNameLabel.text = station.stationName;
    self.bikesAvailableLabel.text = [NSString stringWithFormat:@"Dostnępne rowery: %ld", (long)[station getBikesAvailable]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
