//
//  User.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 26/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "User.h"

NSString* const UserPhoneNumberKey = @"username";
NSString* const UserAuthKeyKey = @"authKey";

@implementation User
- (instancetype)initUserWithPhoneNumber:(NSString *)phoneNumber authKey:(NSString *)authKey {
    if((self = [super init])) {
        self.phoneNumber = phoneNumber;
        self.authKey = authKey;
    }
    return self;
}
- (instancetype)initWithDictionary: (NSDictionary *) dictionary {
    return [self initUserWithPhoneNumber:dictionary[UserPhoneNumberKey] authKey:dictionary[UserAuthKeyKey]];
}
- (NSDictionary*)dictionaryRepresentation {
    return @{
             UserPhoneNumberKey: self.phoneNumber,
             UserAuthKeyKey: self.authKey ? self.authKey : @""
             };
}
@end
