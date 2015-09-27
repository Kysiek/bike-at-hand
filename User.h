//
//  User.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 26/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString* phoneNumber;
- (instancetype) initUserWithPhoneNumber: (NSString*) phoneNumber;
- (instancetype) initWithDictionary: (NSDictionary *) dictionary;
@end
