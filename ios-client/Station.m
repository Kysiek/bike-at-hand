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
    newStation.latitude = [dictionary valueForKey:latitudeKey];
    newStation.longitude = [dictionary valueForKey:longitudeKey];
    newStation.bikes = [dictionary valueForKey:bikesKey];
    newStation.bikesAvailable = [newStation.bikes count];
    return newStation;
}
- (BOOL)hasAvailableBikes {
    return self.bikesAvailable > 0;
}
-(NSString*)bikesAvailabilityString {
    return [NSString stringWithFormat:@"%ld rowerów dostępnych",self.bikesAvailable];
}
-(NSInteger)getBikesAvailable {
    return self.bikes.count;
}
-(NSString*)prettifyDistance {
    NSInteger distance = [self.distance intValue];
    if(distance < 1000) {
        return [NSString stringWithFormat:@"%ld m",(long)distance];
    }
    return [NSString stringWithFormat:@"%ld m",(long)distance];
}
@end