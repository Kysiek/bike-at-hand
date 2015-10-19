//
//  User.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 26/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString* const UserPhoneNumberKey;
extern NSString* const UserAuthKeyKey;
@interface User : NSObject
@property (nonatomic, strong) NSString* phoneNumber;
@property (nonatomic, strong) NSString* authKey;
- (instancetype)initUserWithPhoneNumber: (NSString*) phoneNumber authKey:(NSString*)authKey;
- (instancetype)initWithDictionary: (NSDictionary *) dictionary;
- (NSDictionary*)dictionaryRepresentation;
@end
