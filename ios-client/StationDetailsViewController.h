//
//  StationDetailsViewController.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 10/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"

@interface StationDetailsViewController : UIViewController<UITableViewDataSource>
@property (nonatomic, strong) Station* station;
@end
