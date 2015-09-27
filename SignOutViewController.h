//
//  SignOutViewController.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 27/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const UserSignedOutNotification;

@protocol SignOutProcessDelegate
- (void) signOutProcessComplete;
@end

@interface SignOutViewController : UIViewController
@property (nonatomic, weak) id<SignOutProcessDelegate> delegate;
@end
