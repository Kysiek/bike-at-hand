//
//  User.h
//  bike@hand
//
//  Created by Krzysztof Maciążek on 25/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString* const UserPhoneNumberKey;
extern NSString* const UserAuthKeyKey;
@interface User : NSObject
@property (nonatomic, strong) NSString* phoneNumber;
@property (nonatomic, strong) NSString* authKey;
- (instancetype)initWithDictionary: (NSDictionary *) dictionary;
- (NSDictionary*)dictionaryRepresentation;
@end