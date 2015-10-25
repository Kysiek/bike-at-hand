//
//  ErrorMessage.h
//  bike@hand
//
//  Created by Krzysztof Maciążek on 21/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorMessage : NSObject
@property (nonatomic, strong) NSString* errorTitle;
@property (nonatomic, strong) NSString* errorMessage;
- (instancetype) initErrorMessageWithTitle:(NSString*) errorTitle;
- (instancetype) initErrorMEssageWithTitle:(NSString*) errorTitle withMessage: (NSString*) errorMessage;
@end
