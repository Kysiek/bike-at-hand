//
//  MapStationViewController.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 05/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MainViewController.h"

@interface MapStationViewController : MainViewController
@property (weak,nonatomic) NSArray* stations;
@end
