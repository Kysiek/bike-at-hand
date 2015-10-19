//
//  SignInViewController.h
//  bike@hand
//
//  Created by Krzysztof Maciążek on 19/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* LoginSuccessNotification;
extern NSString* LoginFailureNotification;

@protocol SignInViewControllerDelegate;
@interface SignInViewController : UIViewController
@property (nonatomic, weak) id<SignInViewControllerDelegate> delegate;
@end

@protocol SignInViewControllerDelegate
- (void)signInControllerFinished:(NSString *) signInVC;
@end