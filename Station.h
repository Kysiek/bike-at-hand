//
//  Station.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 20/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject



@property (nonatomic, strong) NSString* stationName;
@property (nonatomic) NSInteger stationNumber;
@property (nonatomic, strong) NSString* bikesAvailable;
@property (nonatomic) NSInteger bikeRacks;
@property (nonatomic, strong) NSNumber* latitude;
@property (nonatomic, strong) NSNumber* longitude;
@property (nonatomic,strong) NSMutableArray* bikes;

+(Station*)stationFromDictionary: (NSDictionary*) dictionary;
-(NSString*)bikesAvailabilityString;
-(NSInteger)getBikesAvailable;
@end
