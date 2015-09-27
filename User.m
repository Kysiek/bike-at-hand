//
//  User.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 26/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "User.h"

static NSString* const UserPhoneNumberKey = @"name";

@implementation User
- (instancetype) initUserWithPhoneNumber:(NSString *)phoneNumber {
    if((self = [super init])) {
        self.phoneNumber = phoneNumber;
    }
    return self;
}
- (instancetype) initWithDictionary: (NSDictionary *) dictionary {
    return [self initUserWithPhoneNumber:dictionary[UserPhoneNumberKey]];
}
@end
