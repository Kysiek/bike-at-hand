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
@property (weak, nonatomic) IBOutlet UIView *loginInProgressView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@end

static NSString* signingInProcess = @"Proszę czekać ...";
static NSString* authenticationCheckingProcess = @"Sprawdzanie czy użytkownik jest zalogowany";

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:UserSignedInNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:UserSignedOutNotification
                                               object:nil];
    
    NSString *userIdentifier = [[UserManagementService getInstance] getUserIdentifier];
    
    if(userIdentifier) {
        self.phoneNumberField.text = userIdentifier;
    }
    [[UserManagementService getInstance] checkIfUserIsAuthenticated];
}
- (void) receivedNotification:(NSNotification *) notification {
    
    if ([[notification name] isEqualToString:UserSignedInNotification]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf performSegueWithIdentifier:@"userAuthenticatedSegue" sender:weakSelf];
        });
    } else if ([[notification name] isEqualToString:UserSignedOutNotification]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideWaitUI];
            weakSelf.loadingLabel.text = signingInProcess;
        });
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
             [weakSelf performSegueWithIdentifier:@"userAuthenticatedSegue" sender:weakSelf];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}
#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Helpers

- (void)showWaitUI {
    self.loginView.hidden = YES;
    self.loginInProgressView.hidden = NO;
}

- (void)hideWaitUI {
    self.loginView.hidden = NO;
    self.loginInProgressView.hidden = YES;
}

@end
