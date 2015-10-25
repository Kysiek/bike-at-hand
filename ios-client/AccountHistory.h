//
//  AccountHistory.h
//  bike@hand
//
//  Created by Krzysztof Maciążek on 21/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountHistory : NSObject
@property (nonatomic, strong) NSString *stationFrom;
@property (nonatomic, strong) NSString *stationTo;
@property (nonatomic, strong) NSString *bikeNumber;
@property (nonatomic, strong) NSString *timeFrom;
@property (nonatomic, strong) NSString *timeTo;
@property (nonatomic, strong) NSDate *startDay;
@property (nonatomic, strong) NSString *startDayString;
- (instancetype)initWithDictionary:(NSDictionary*) dictionary;
@end
