//
//  StationListCustomCellTableViewCell.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 21/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"

@interface StationListCustomCellTableViewCell : UITableViewCell
- (void)setLabels:(Station*) station;
@end
