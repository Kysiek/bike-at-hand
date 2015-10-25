//
//  User.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 25/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "User.h"

NSString* const UserPhoneNumberKey = @"username";
NSString* const UserAuthKeyKey = @"auth_token";

@implementation User
- (instancetype)initWithDictionary: (NSDictionary *) dictionary {
    if((self = [super init])) {
        self.phoneNumber = dictionary[UserPhoneNumberKey] ? dictionary[UserPhoneNumberKey] : nil;
        self.authKey = dictionary[UserAuthKeyKey];
    }
    return self;
}
- (NSDictionary*)dictionaryRepresentation {
    return @{
             UserPhoneNumberKey: self.phoneNumber,
             UserAuthKeyKey: self.authKey ? self.authKey : @""
             };
}
@end
