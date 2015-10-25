//
//  Station.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 21/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "Station.h"
#import "Bike.h"

@implementation Station

static NSString* stationNameKey = @"name";
static NSString* stationNumberKey = @"id";
static NSString* bikesRacksKey = @"racks_count";
static NSString* bikesKey = @"bikes";
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
+(NSArray*) getStations:(NSArray*)stations forSearchPhrase: (NSString*) searchPhrase {
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    for(Station *station in stations) {
        if([[station.stationName lowercaseString] containsString:searchPhrase]) {
            [resultArray addObject:station];
        }
    }
    return resultArray;
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