//
//  AccountHistoryTableViewCell.h
//  bike@hand
//
//  Created by Krzysztof Maciążek on 19/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountHistory.h"

@interface AccountHistoryTableViewCell : UITableViewCell
- (void)setLabels:(AccountHistory*) accountHistory;

@end
