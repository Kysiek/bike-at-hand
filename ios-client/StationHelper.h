//
//  StationHelper.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 20/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StationsLoadedDelegate
-(void)stationsLoaded:(NSArray *)stations;
@end

@interface StationHelper : NSObject<NSXMLParserDelegate>


@property (nonatomic, assign) id<StationsLoadedDelegate> delegate;

- (void) parseXMLData:(NSData*)xmlData;
- (void) getStationsByCityId:(NSString*) cityId;
@end
