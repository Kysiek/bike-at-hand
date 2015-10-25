//
//  AccountHistory.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 21/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "AccountHistory.h"

const NSString* stationFromKey = @"stationFrom";
const NSString* stationToKey = @"stationTo";
const NSString* bikeNumberKey = @"bikeNumber";
const NSString* timeFromKey = @"startTime";
const NSString* timeToKey = @"endTime";
const NSString* startDayKey = @"startDay";
const NSString* dateFormat = @"MM.dd.yyyy";

@implementation AccountHistory
- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if((self = [super init])) {
        self.stationFrom = [dictionary objectForKey:stationFromKey];
        self.stationTo  = [dictionary objectForKey:stationToKey];
        self.bikeNumber = [dictionary objectForKey:bikeNumberKey];
        self.timeFrom = [dictionary objectForKey:timeFromKey];
        self.timeTo = [dictionary objectForKey:timeToKey];
        self.startDayString = [dictionary objectForKey:startDayKey];
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"MM.dd.yyyy";
        self.startDay = [formatter dateFromString:self.startDayString];
    }
    return self;
}
@end
