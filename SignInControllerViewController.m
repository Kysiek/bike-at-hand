//
//  SignInControllerViewController.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 26/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "SignInControllerViewController.h"
#import "UserManagementService.h"
#import "MapViewController.h"

static NSString* const SignedInSegue = @"SignedInSegue";
NSString* const UserSignedInNotification = @"UserSignedInNotification";

@interface SignInControllerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *pinNumberField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIView *authenticationInProgressView;


@end

@implementation SignInControllerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.barButton.title = signViewControllerTitle;
    NSString *userIdentifier = [[UserManagementService getInstance] getUserIdentifier];
    if(userIdentifier) {
        self.phoneNumberField.text = userIdentifier;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTabSignInButton:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self showWaitUI];
    [[UserManagementService getInstance]
        signInWithPhoneNumber:self.phoneNumberField.text
                    pinNumber:self.pinNumberField.text
                        success: ^(void) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [weakSelf hideWaitUI];
                               [self performSegueWithIdentifier:SignedInSegue sender:nil];
                               
                               //sending notifications that user is signed in
                               [[NSNotificationCenter defaultCenter] postNotificationName:UserSignedInNotification object:nil];
                           });
                        }
                       failure:^(ErrorMessage *error) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [weakSelf hideWaitUI];
                               [weakSelf showErrorMessage:error forViewController:self];
                           });
                       }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:SignedInSegue]) {
        //We are going to open MapView
    }
}

#pragma mark - Helpers

- (void)showWaitUI {
    self.signInButton.hidden = YES;
    self.authenticationInProgressView.hidden = NO;
}

- (void)hideWaitUI {
    self.signInButton.hidden = NO;
    self.authenticationInProgressView.hidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
