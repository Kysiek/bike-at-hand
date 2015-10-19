//
//  SignInViewController.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 19/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "SignInViewController.h"
#import "UserManagementService.h"
#import "ErrorMessage.h"

NSString* LoginSuccessNotification = @"LoginSuccessNotification";
NSString* LoginFailureNotification = @"LoginFailureNotification";

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *pinNumberField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIView *loginInProgressView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *userIdentifier = [[UserManagementService getInstance] getUserIdentifier];
    if(userIdentifier) {
        self.phoneNumberField.text = userIdentifier;
    }
}
- (IBAction)didTapSignInButton:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self showWaitUI];
    [[UserManagementService getInstance]
     signInWithPhoneNumber:self.phoneNumberField.text
     pinNumber:self.pinNumberField.text
     success: ^(void) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf hideWaitUI];
             [self.delegate signInControllerFinished:LoginSuccessNotification];
         });
     }
     failure:^(ErrorMessage *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf hideWaitUI];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:error.errorTitle
                                                                            message:error.errorMessage
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {}];
             
             [alert addAction:defaultAction];
             [weakSelf presentViewController:alert animated:YES completion:nil];
         });
     }];
}
- (IBAction)didTapBackButton:(id)sender {
    [self.delegate signInControllerFinished:LoginFailureNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

- (void)showWaitUI {
    self.signInButton.hidden = YES;
    self.loginInProgressView.hidden = NO;
}

- (void)hideWaitUI {
    self.signInButton.hidden = NO;
    self.loginInProgressView.hidden = YES;
}

@end
