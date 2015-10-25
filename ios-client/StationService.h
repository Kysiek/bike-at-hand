//
//  StationService.h
//  bike@hand
//
//  Created by Krzysztof Maciążek on 21/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorMessage.h"
#import "Station.h"

extern NSString * const StationsArrivalNotification;
extern NSString * const StationsErrorNotification;

@interface StationService : NSObject
+ (StationService*) getInstance;
- (Station*)getStationForName:(NSString*)stationName;
- (void)fetchStations;
- (NSArray*) getStationsArray;
- (ErrorMessage*) getErrorMessage;
@end
