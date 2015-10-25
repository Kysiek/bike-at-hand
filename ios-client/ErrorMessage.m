//
//  ErrorMessage.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 21/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "ErrorMessage.h"

@implementation ErrorMessage
- (instancetype) initErrorMessageWithTitle:(NSString *)errorTitle {
    if((self = [super init])) {
        self.errorTitle = errorTitle;
    }
    return self;
}
- (instancetype) initErrorMEssageWithTitle:(NSString *)errorTitle withMessage:(NSString *)errorMessage {
    if((self = [self initErrorMessageWithTitle:errorTitle])) {
        self.errorMessage = errorMessage;
    }
    return self;
}
@end
