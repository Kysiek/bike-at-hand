//
//  StationDetailsViewController.h
//  bike@hand
//
//  Created by Krzysztof Maciążek on 20/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"
@protocol StationDetailsViewControllerDelegate
-(void) didTabExitButtonInStationDetailsController;
@end

@interface StationDetailsViewController : UIViewController<UITableViewDataSource>
@property (nonatomic, strong) Station* station;
@property (nonatomic, weak) id<StationDetailsViewControllerDelegate> delegate;
@end
