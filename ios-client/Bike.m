//
//  Bike.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 20/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "Bike.h"

@implementation Bike

static NSString* bikesSeparator = @",";
-(Bike*)initWithStringBikeNumber:(NSString*) bikeNumberString {
    if ( self = [super init] ) {
        self.bikeNumber = [bikeNumberString integerValue];
    }
    return self;
}
+(NSMutableArray*)bikesFromString:(NSString *)bikesString {
    NSArray* bikesNumbersArray = [bikesString componentsSeparatedByString:bikesSeparator];
    NSInteger numberOfBikes = [bikesNumbersArray count];
    NSMutableArray* bikesArray = [[NSMutableArray alloc] initWithCapacity:numberOfBikes];
    for(NSString* bikeNumber in bikesNumbersArray) {
        [bikesArray addObject:[[Bike alloc] initWithStringBikeNumber:bikeNumber]];
    }
    return bikesArray;
}
@end
