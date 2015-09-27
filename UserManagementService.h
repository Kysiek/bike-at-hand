//
//  UserManagementService.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 26/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorMessage.h"

extern NSString * const UserIdentifierKey;

@interface UserManagementService : NSObject
+ (UserManagementService*)getInstance;

- (void)signInWithPhoneNumber:(NSString*) phoneNumber
                    pinNumber:(NSString*) pinNumber
                      success:(void(^)())success
                      failure:(void(^)(ErrorMessage *error))failure;
- (void)signOutWithSuccess:(void(^)())success
                   failure:(void(^)(ErrorMessage *error))failure;
- (BOOL)isUserSignedId;
- (NSString*)getUserIdentifier;
@end
