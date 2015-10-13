//
//  AccountHistoryCellViewTableViewCell.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 03/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountHistory.h"

@interface AccountHistoryCellViewTableViewCell : UITableViewCell
- (void)setLabels:(AccountHistory*) accountHistory;
@end
