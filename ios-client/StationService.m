//
//  StationService.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 21/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "StationService.h"
#import "ConnectionHelper.h"

NSString * const StationsArrivalNotification = @"StationsArrivalNotification";
NSString * const StationsErrorNotification = @"StationsErrorNotification";

@interface StationService()
@property (nonatomic, strong) NSArray* stationArray;
@property (nonatomic, strong) ErrorMessage *errorMessage;


@end
@implementation StationService


static StationService * stationService;


+ (StationService*)getInstance{
    if (stationService == nil) {
        stationService = [[super alloc] init];
    }
    return stationService;
}
const NSString* stationsKey = @"stations";
-(void) fetchStations {
    __weak typeof(self) weakSelf = self;
    [[ConnectionHelper mainConnectionHelper]
     submitGETPath:@"/stations/all"
     body:nil
     expectedStatus:200
     success:^(NSData *data) {
         NSError *error = nil;
         NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         
         if(result &&
            [result isKindOfClass:[NSDictionary class]] &&
            [[result objectForKey:stationsKey] isKindOfClass:[NSArray class]]) {
             
             NSArray* resultArray = [result objectForKey:stationsKey];
             NSMutableArray* stations = [[NSMutableArray alloc] initWithCapacity:resultArray.count];
             for(NSDictionary* dictionary in resultArray) {
                 [stations addObject:[Station stationFromDictionary:dictionary]];
             }
             weakSelf.stationArray = stations;
             weakSelf.errorMessage = nil;
             
             //sending notifications that stations has been downloaded
             [[NSNotificationCenter defaultCenter] postNotificationName:StationsArrivalNotification object:nil];
             
         } else {
             weakSelf.errorMessage = [[ErrorMessage alloc] initErrorMEssageWithTitle:@"Parsing error" withMessage:@"Cannot parse data. Received format different than expected"];
             
             //sending notification that sth gone wrong with downloading stations
             [[NSNotificationCenter defaultCenter] postNotificationName:StationsErrorNotification object:nil];
         }
     } failure:^(ErrorMessage *error) {
         weakSelf.errorMessage = error;
         
         //sending notification that sth gone wrong with downloading stations
         [[NSNotificationCenter defaultCenter] postNotificationName:StationsErrorNotification object:nil];
     }];
}
-(Station*)getStationForName:(NSString *)stationName {
    if(self.stationArray) {
        for(Station *station in self.stationArray) {
            if([station.stationName isEqualToString:stationName]) {
                return station;
            }
        }
    }
    return NULL;
}
-(NSArray*) getStationsArray {
    if(self.stationArray == nil) {
        [self fetchStations];
    }
    return self.stationArray;
}
-(ErrorMessage*) getErrorMessage {
    return self.errorMessage;
}
-(void)stationsLoaded:(NSArray *)stations {
    self.stationArray = stations;
}
@end
