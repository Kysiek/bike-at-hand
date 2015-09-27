//
//  SignOutViewController.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 27/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "SignOutViewController.h"
#import "UserManagementService.h"

NSString* const UserSignedOutNotification = @"UserSignedOutNotification";

@interface SignOutViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signOutButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *inProgressView;
@property (weak, nonatomic) IBOutlet UILabel *confirmationLabel;


@end

@implementation SignOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapSignOutButton:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self showWaitUI];
    [[UserManagementService getInstance]
     signOutWithSuccess:^(void) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [weakSelf hideWaitUI];
                               
                               //sending notifications that user is signed out
                               [[NSNotificationCenter defaultCenter] postNotificationName:UserSignedOutNotification object:nil];
                               [self.delegate signOutProcessComplete];
                           });
                       }
                       failure:^(ErrorMessage *error) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [weakSelf hideWaitUI];
                               [self.delegate signOutProcessComplete];
                           });
                       }];
}
- (IBAction)didTapBackButton:(id)sender {
    [self.delegate signOutProcessComplete];
}

#pragma mark - Helpers

- (void)showWaitUI {
    self.confirmationLabel.hidden = YES;
    self.signOutButton.hidden = YES;
    self.backButton.hidden = YES;
    self.inProgressView.hidden = NO;
}

- (void)hideWaitUI {
    self.confirmationLabel.hidden = NO;
    self.signOutButton.hidden = NO;
    self.backButton.hidden = NO;
    self.inProgressView.hidden = YES;
}

@end
