//
//  StationListTableViewCell.h
//  bike@hand
//
//  Created by Krzysztof Maciążek on 18/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"

@interface StationListTableViewCell : UITableViewCell
- (void)setLabels:(Station*) station;
@end
