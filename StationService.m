//
//  StationManager.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 21/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "StationService.h"
#import "ConnectionHelper.h"
#import "Station.h"

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

-(void) fetchStations {
    __weak typeof(self) weakSelf = self;
    [[ConnectionHelper mainConnectionHelper]
     submitGETPath:@"/stations/all"
            body:nil
        expectedStatus:254
            success:^(NSData *data) {
        NSError *error = nil;
        NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(result && [result isKindOfClass:[NSArray class]]) {
            NSMutableArray* stations = [[NSMutableArray alloc] initWithCapacity:result.count];
            for(NSDictionary* dictionary in result) {
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
