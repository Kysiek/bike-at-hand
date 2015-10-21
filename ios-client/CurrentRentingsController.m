//
//  CurrentRentingsController.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 19/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "CurrentRentingsController.h"
#import "UserManagementService.h"

@interface CurrentRentingsController ()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (nonatomic, strong) UserManagementService* userService;
@end

@implementation CurrentRentingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userService = [UserManagementService getInstance];
    if([self.userService isUserSignedId]) {
        [self replaceViews];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SignInViewControllerDelegate

- (void)signInControllerFinished:(NSString *) signInMessage {
    if([signInMessage isEqualToString:LoginSuccessNotification]) {
        [self replaceViews];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        SignInViewController *authVC = (SignInViewController *)segue.destinationViewController;
        authVC.delegate = self;
    }
}
static NSString* LoggedInInfo = @"Nie masz żadnych wypożyczeń";
- (void)replaceViews {
    self.signInButton.hidden = YES;
    self.stateLabel.text = LoggedInInfo;
}
@end
