//
//  ConnectionHelper.h
//  bike@hand
//
//  Created by Krzysztof Maciążek on 21/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ErrorMessage.h"

@interface ConnectionHelper : NSObject
+(ConnectionHelper*) mainConnectionHelper;

//TODO: Refactor: make one one method instead of 4 belowed, as they have the same arguments (except submitDELETEPath - is it necessary?). This new method should take requestMethod argument.
- (void)submitGETPath:(NSString *)path
                 body:(NSDictionary *)bodyDict
       expectedStatus:(NSInteger)expectedStatus
              success:(void(^)(NSData *data))success
              failure:(void(^)(ErrorMessage *error))failure;

- (void)submitPOSTPath:(NSString *)path
                  body:(NSDictionary *)bodyDict
        expectedStatus:(NSInteger)expectedStatus
               success:(void(^)(NSData *data))success
               failure:(void(^)(ErrorMessage *error))failure;

- (void)submitPUTPath:(NSString *)path
                 body:(NSDictionary *)bodyDict
       expectedStatus:(NSInteger)expectedStatus
              success:(void(^)(NSData *data))success
              failure:(void(^)(ErrorMessage *error))failure;

- (void)submitDELETEPath:(NSString *)path
                 success:(void(^)(NSData *data))success
                 failure:(void(^)(ErrorMessage *error))failure;
@end
