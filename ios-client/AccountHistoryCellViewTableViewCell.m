//
//  AccountHistoryCellViewTableViewCell.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 03/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "AccountHistoryCellViewTableViewCell.h"
@interface AccountHistoryCellViewTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bikeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;


@end

@implementation AccountHistoryCellViewTableViewCell

- (void)setLabels:(AccountHistory *)accountHistory {
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@ - %@",accountHistory.startDayString, accountHistory.timeFrom, accountHistory.timeTo ];
    self.bikeNumberLabel.text = accountHistory.bikeNumber;
    self.routeLabel.text = [NSString stringWithFormat:@"%@ - %@", accountHistory.stationFrom, accountHistory.stationTo];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
