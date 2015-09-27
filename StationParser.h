//
//  StationParser.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 20/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StationParser : NSObject<NSXMLParserDelegate>
@property NSMutableArray* stationArray;

- (id)initWithArray: (NSMutableArray*) stationArray;
- (void)parseXMLFile:(NSData*) xmlData;
@property (nonatomic) id<StationsLoadedDelegate> delegate;

@end
