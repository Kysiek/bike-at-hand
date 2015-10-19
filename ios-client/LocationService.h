//
//  LocationService.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 07/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

extern NSString * const LocationArrivalNotification;

@interface LocationService : NSObject
+ (LocationService*)getInstance;
- (CLLocation*)getUserLocation;
- (void)initLocationManager;
@end
