//
//  Bike.h
//  bike@hand
//
//  Created by Krzysztof Maciążek on 20/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bike : NSObject
@property (nonatomic) NSInteger bikeNumber;
-(Bike*)initWithStringBikeNumber:(NSString*) bikeNumber;
+(NSMutableArray*)bikesFromString:(NSString*) bikesString;
@end
