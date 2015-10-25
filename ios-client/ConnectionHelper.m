//
//  ConnectionHelper.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 21/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "ConnectionHelper.h"
#import "Configuration.h"

@implementation ConnectionHelper
static ConnectionHelper* mainHelper;
+(ConnectionHelper*)mainConnectionHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainHelper = [[ConnectionHelper alloc] init];
    });
    return mainHelper;
}
#pragma mark - API methods
- (void)submitGETPath:(NSString *)path
                 body:(NSDictionary *)bodyDict
       expectedStatus:(NSInteger)expectedStatus
              success:(void(^)(NSData *data))success
              failure:(void(^)(ErrorMessage *error))failure {
    NSURL *URL = [self URLWithPath:path];
    return [self submitRequestWithURL:URL
                               method:@"GET"
                                 body:bodyDict
                       expectedStatus:expectedStatus
                              success:success
                              failure:failure];
}
- (void)submitPOSTPath:(NSString *)path
                  body:(NSDictionary *)bodyDict
        expectedStatus:(NSInteger)expectedStatus
               success:(void(^)(NSData *data))success
               failure:(void(^)(ErrorMessage *error))failure {
    NSURL *URL = [self URLWithPath:path];
    return [self submitRequestWithURL:URL
                               method:@"POST"
                                 body:bodyDict
                       expectedStatus:expectedStatus
                              success:success
                              failure:failure];
}
- (void)submitPUTPath:(NSString *)path
                 body:(NSDictionary *)bodyDict
       expectedStatus:(NSInteger)expectedStatus
              success:(void(^)(NSData *data))success
              failure:(void(^)(ErrorMessage *error))failure {
    NSURL *URL = [self URLWithPath:path];
    return [self submitRequestWithURL:URL
                               method:@"PUT"
                                 body:bodyDict
                       expectedStatus:expectedStatus
                              success:success
                              failure:failure];
}
- (void)submitDELETEPath:(NSString *)path
                 success:(void(^)(NSData *data))success
                 failure:(void(^)(ErrorMessage *error))failure {
    
    NSURL *URL = [self URLWithPath:path];
    return [self submitRequestWithURL:URL
                               method:@"DELETE"
                                 body:nil
                       expectedStatus:200
                              success:success
                              failure:failure];
}
#pragma mark - Request Helpers

- (NSURL *)URLWithPath:(NSString *)path {
    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:rootURL]];
}
- (NSData *)encodedBody:(NSDictionary *)parameters {
    
    NSError *error;
    return [NSJSONSerialization  dataWithJSONObject:parameters options:0 error:&error];
}
- (NSMutableURLRequest *)requestForURL:(NSURL *)URL
                                method:(NSString *)httpMethod
                              bodyDict:(NSDictionary *)bodyDict {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:httpMethod];
    if (bodyDict) {
        [request setHTTPBody:[self encodedBody:bodyDict]];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}
- (void)submitRequestWithURL:(NSURL *)URL
                      method:(NSString *)httpMethod
                        body:(NSDictionary *)bodyDict
              expectedStatus:(NSInteger)expectedStatus
                     success:(void(^)(NSData *data))success
                     failure:(void(^)(ErrorMessage *error))failure {
    
    NSMutableURLRequest *request = [self requestForURL:URL
                                                method:httpMethod
                                              bodyDict:bodyDict];
    
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                     NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *) response;
                                                                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                                     if(HTTPResponse.statusCode == expectedStatus) {
                                                                         success(data);
                                                                     } else {
                                                                         NSString *message = [NSString stringWithFormat:@"Unexpected response code: %li", (long)HTTPResponse.statusCode];
                                                                         
                                                                         if (data) {
                                                                             NSError *jsonError = nil;
                                                                             id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                                                             if (json && [json isKindOfClass:[NSDictionary class]]) {
                                                                                 NSString *errorMessage = [(NSDictionary *)json valueForKey:@"error"];
                                                                                 if (errorMessage) {
                                                                                     message = errorMessage;
                                                                                 }
                                                                             }
                                                                         }
                                                                         ErrorMessage *errorMessage = [[ErrorMessage alloc] initErrorMEssageWithTitle:message withMessage:[NSString stringWithFormat:@"Status code: %li",HTTPResponse.statusCode]];
                                                                         failure(errorMessage);
                                                                     }
                                                                     
                                                                 }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [task resume];
}

@end