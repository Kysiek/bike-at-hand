//
//  LocationService.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 07/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "LocationService.h"

@interface LocationService () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@end

@implementation LocationService
static LocationService* instance;
+ (LocationService*)getInstance {
    if(!instance) {
        instance = [[LocationService alloc] init];
    }
    return instance;
}
- (void)initLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
}
- (CLLocation*)getUserLocation {
    CLLocationDegrees latitude = [@"51.1103241" doubleValue];
    CLLocationDegrees longitude = [@"17.03123465" doubleValue];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    //return self.currentLocation;
    return location;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [locations lastObject];
}
@end
