//
//  Station.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 20/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "Station.h"
#import "Bike.h"

@implementation Station

static NSString* stationNameKey = @"stationName";
static NSString* stationNumberKey = @"stationNumber";
static NSString* bikesAvailableKey = @"numberOfAvailableBikes";
static NSString* bikesRacksKey = @"bikeRacks";
static NSString* bikesKey = @"listOfBikes";
static NSString* latitudeKey = @"latitude";
static NSString* longitudeKey = @"longitude";

+(Station*) stationFromDictionary:(NSDictionary *)dictionary {
    Station *newStation = [[Station alloc] init];
    newStation.stationName = [dictionary valueForKey: stationNameKey];
    newStation.bikeRacks = [[dictionary valueForKey: bikesRacksKey] integerValue];
    newStation.stationNumber  = [[dictionary valueForKey:stationNumberKey] integerValue];
    newStation.bikesAvailable = [dictionary valueForKey:bikesAvailableKey];
    newStation.latitude = [dictionary valueForKey:latitudeKey];
    newStation.longitude = [dictionary valueForKey:longitudeKey];
    newStation.bikes = [dictionary valueForKey:bikesKey];
    return newStation;
}
-(NSString*)bikesAvailabilityString {
    return [NSString stringWithFormat:@"%@ rowerów dostępnych",self.bikesAvailable];
}
-(NSInteger)getBikesAvailable {
    return self.bikes.count;
}
@end
