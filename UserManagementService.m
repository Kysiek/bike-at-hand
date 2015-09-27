//
//  UserManagementService.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 26/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "UserManagementService.h"
#import "ConnectionHelper.h"
#import "User.h"

NSString * const UserIdentifierKey = @"UserIdentifier";

@interface UserManagementService()
@property (nonatomic, strong) User* currentUser;
@end
@implementation UserManagementService

static UserManagementService * userManagementService;

+ (UserManagementService*)getInstance{
    if (userManagementService == nil) {
        userManagementService = [[super alloc] init];
    }
    return userManagementService;
}
#pragma marka - API methods
-(void)signInWithPhoneNumber:(NSString *)phoneNumber
                   pinNumber:(NSString *)pinNumber
                     success:(void (^)())success
                     failure:(void (^)(ErrorMessage *))failure {
    
    NSDictionary *params = @{
                             @"user[name]":phoneNumber,
                             @"user[password]":pinNumber};
    ConnectionHelper *connHelper = [ConnectionHelper mainConnectionHelper];
    __weak typeof(self) weakSelf = self;
    
    [connHelper submitPUTPath:@"/account"
                         body:params
               expectedStatus:201
                      success:^(NSData *data) {
                       NSError *error = nil;
                       NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                          if (userDict && [userDict isKindOfClass:[NSDictionary class]]) {
                              weakSelf.currentUser = [[User alloc] initWithDictionary:userDict];
                              [self persistServerRootAndUserIdentifier];
                              if (success != NULL) {
                                  success();
                              }
                          }
                      }
                      failure:failure];
}
- (void)signOutWithSuccess:(void(^)())success
                   failure:(void(^)(ErrorMessage *error))failure {
    ConnectionHelper *connHelper = [ConnectionHelper mainConnectionHelper];
    [connHelper submitDELETEPath:@"/account"
                         success:^(NSData *data) {
                             self.currentUser = nil;
                             if (success != NULL) {
                                 success();
                             }
                         }
                         failure:failure];
}
- (NSString*)getUserIdentifier {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:UserIdentifierKey];
}
- (BOOL)isUserSignedId {
    return NO;
}
#pragma mark - Private Helpers
- (void)persistServerRootAndUserIdentifier {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.currentUser.phoneNumber forKey:UserIdentifierKey];
    [defaults synchronize];
}
@end
