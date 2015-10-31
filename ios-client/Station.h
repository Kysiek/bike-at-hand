//
//  Station.h
//  bike@hand
//
//  Created by Krzysztof Maciążek on 21/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject

@property (nonatomic, strong) NSString* stationName;
@property (nonatomic) NSInteger stationNumber;
@property (nonatomic) NSInteger bikesAvailable;
@property (nonatomic) NSInteger bikeRacks;
@property (nonatomic, strong) NSNumber* latitude;
@property (nonatomic, strong) NSNumber* longitude;
@property (nonatomic,strong) NSMutableArray* bikes;
@property (nonatomic, strong) NSNumber* distance;

+(Station*)stationFromDictionary: (NSDictionary*) dictionary;
+(NSArray*) getStations:(NSArray*)stations forSearchPhrase: (NSString*) searchPhrase;
-(NSString*)bikesAvailabilityString;
-(NSInteger)getBikesAvailable;
-(BOOL)hasAvailableBikes;
-(NSString*)prettifyDistance;
-(BOOL)hasLowAvailability;
@end
