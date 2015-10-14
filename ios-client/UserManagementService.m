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
#import "AccountHistory.h"
#import "StationService.h"

NSString * const UserIdentifierKey = @"UserIdentifier";
NSString* const UserSignedOutNotification = @"UserSignedOutNotification";
NSString* const UserSignedInNotification = @"UserSignedInNotification";
NSString * const UserHistoryAccountArrived = @"UserHistoryAccountArrived";

@interface UserManagementService()
@property (nonatomic, strong) User* currentUser;
@property (nonatomic, strong) NSArray* accountHistoryArray;
@end
@implementation UserManagementService

static UserManagementService * userManagementService;

+ (UserManagementService*)getInstance{
    if (userManagementService == nil) {
        userManagementService = [[UserManagementService alloc] init];
    }
    return userManagementService;
}
- (instancetype)init {
    if((self = [super init])) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary* userDict = [defaults objectForKey:UserIdentifierKey];
        if(userDict && [self.currentUser isKindOfClass:[NSDictionary class]]) {
            self.currentUser = [[User alloc] initWithDictionary:userDict];
        }
    }
    return self;
}
#pragma marka - API methods
-(void)signInWithPhoneNumber:(NSString *)phoneNumber
                   pinNumber:(NSString *)pinNumber
                     success:(void (^)())success
                     failure:(void (^)(ErrorMessage *))failure {
    
    NSDictionary *params = @{
                             @"user":phoneNumber,
                             @"pass":pinNumber};
    ConnectionHelper *connHelper = [ConnectionHelper mainConnectionHelper];
    __weak typeof(self) weakSelf = self;
    
    [connHelper submitPOSTPath:@"/account/login"
                         body:params
               expectedStatus:251
                      success:^(NSData *data) {
                       NSError *error = nil;
                       NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                          if (userDict && [userDict isKindOfClass:[NSDictionary class]]) {
                              weakSelf.currentUser = [[User alloc] initWithDictionary:userDict];
                              [self persistSignInUserInformation];
                              [self informThatUserIsSignIn];
                              if (success != NULL) {
                                  success();
                              }
                          }
                      }
                      failure:failure];
}
- (void)signOutWithSuccess:(void(^)())success
                   failure:(void(^)(ErrorMessage *error))failure {
    [[ConnectionHelper mainConnectionHelper]
                submitGETPath:[NSString stringWithFormat:@"/account/logout?authKey=%@&user=%@",
                    self.currentUser.authKey,
                    self.currentUser.phoneNumber]
                         body:nil
               expectedStatus:252
                     success:^(NSData *data) {
                             self.currentUser = nil;
                             [self informThatUserIsSignOut];
                             if (success != NULL) {
                                 success();
                             }
                         }
                     failure:failure];
}
- (void)checkIfUserIsAuthenticated {
    if(self.currentUser
       && self.currentUser.phoneNumber
       && self.currentUser.authKey) {
        
        __weak typeof(self) weakSelf = self;
        
        [[ConnectionHelper mainConnectionHelper]
         submitGETPath:[NSString stringWithFormat:@"/account/logged?authKey=%@&user=%@",
                        self.currentUser.authKey,
                        self.currentUser.phoneNumber]
         body:nil
         expectedStatus:253
         success:^(NSData *data) {
             [weakSelf informThatUserIsSignIn];
         }
         failure:^(ErrorMessage *error) {
             weakSelf.currentUser.authKey = nil;
             [weakSelf persistSignInUserInformation];
         }];
    }
}
- (void)loadAccountHistory {
    __weak typeof(self) weakSelf = self;
    [[ConnectionHelper mainConnectionHelper]
     submitGETPath:[NSString stringWithFormat:@"/account/history?authKey=%@&user=%@",
                    self.currentUser.authKey,
                    self.currentUser.phoneNumber]
     body:nil
     expectedStatus:200
     success:^(NSData *data) {
         
         NSError *error = nil;
         NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         if(result && [result isKindOfClass:[NSArray class]]) {
             NSMutableArray* accountHistoryMutableArray = [[NSMutableArray alloc] initWithCapacity:result.count];
             for(NSDictionary* dictionary in result) {
                 
                 [accountHistoryMutableArray addObject:[[AccountHistory alloc] initWithDictionary:dictionary]];
             }
             weakSelf.accountHistoryArray = accountHistoryMutableArray;
             
             //sending notifications that stations has been downloaded
             [[NSNotificationCenter defaultCenter] postNotificationName:UserHistoryAccountArrived object:nil];
         } else {
             //weakSelf.errorMessage = [[ErrorMessage alloc] initErrorMEssageWithTitle:@"Parsing error" withMessage:@"Cannot parse data. Received format different than expected"];
             
             //sending notification that sth gone wrong with downloading stations
             //[[NSNotificationCenter defaultCenter] postNotificationName:StationsErrorNotification object:nil];
         }
     } failure:^(ErrorMessage *error) {
         //weakSelf.errorMessage = error;
         
         //sending notification that sth gone wrong with downloading stations
         //[[NSNotificationCenter defaultCenter] postNotificationName:StationsErrorNotification object:nil];
     }];
}
- (NSString*)getUserIdentifier {
    if(self.currentUser) {
        return self.currentUser.phoneNumber;
    }
    return nil;
}
- (NSArray*)getAccountHistory {
    return self.accountHistoryArray;
    
}
- (BOOL)isUserSignedId {
    return self.currentUser.phoneNumber && self.currentUser.authKey;
}
#pragma mark - Private Helpers
- (void)informThatUserIsSignIn {
    //sending notifications that user is signed in
    [[NSNotificationCenter defaultCenter] postNotificationName:UserSignedInNotification object:nil];
}
- (void)informThatUserIsSignOut {
    //sending notifications that user is signed out
    [[NSNotificationCenter defaultCenter] postNotificationName:UserSignedOutNotification object:nil];
}
- (void)persistSignInUserInformation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.currentUser dictionaryRepresentation] forKey:UserIdentifierKey];
    [defaults synchronize];
}
@end
