//
//  AccountHistoryTableViewCell.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 19/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "AccountHistoryTableViewCell.h"

@interface AccountHistoryTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bikeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@end

@implementation AccountHistoryTableViewCell

- (void)setLabels:(AccountHistory *)accountHistory {
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@ - %@",accountHistory.startDayString, accountHistory.timeFrom, accountHistory.timeTo ];
    self.bikeNumberLabel.text = [NSString stringWithFormat:@"Rower: %@",accountHistory.bikeNumber];
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
