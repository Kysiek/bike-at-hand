//
//  UserManagementService.h
//  bike@hand
//
//  Created by Krzysztof Maciążek on 21/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorMessage.h"

extern NSString * const UserIdentifierKey;
extern NSString * const UserSignedInNotification;
extern NSString * const UserSignedOutNotification;
extern NSString * const UserHistoryAccountArrived;

@interface UserManagementService : NSObject
+ (UserManagementService*)getInstance;
- (instancetype)init;
- (void)signInWithPhoneNumber:(NSString*) phoneNumber
                    pinNumber:(NSString*) pinNumber
                      success:(void(^)())success
                      failure:(void(^)(ErrorMessage *error))failure;
- (void)signOutWithSuccess:(void(^)())success
                   failure:(void(^)(ErrorMessage *error))failure;
- (void) loadAccountHistory;
- (void)checkIfUserIsAuthenticated;
- (BOOL)isUserSignedId;
- (NSString*)getUserIdentifier;
- (NSArray*)getAccountHistory;
@end
