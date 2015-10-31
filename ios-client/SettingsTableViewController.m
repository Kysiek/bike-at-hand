//
//  SettingsTableViewController.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 28/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "UserManagementService.h"
#import "AppDelegate.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wylogowywanie" message:@"Na pewno chcesz się wylogować?" preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof(self) weakSelf = self;
        UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"Tak"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 __block UIAlertController *waitAlert = [self showWaitAlert];
                                                                 UserManagementService *umService = [UserManagementService getInstance];
                                                                 [umService signOutWithSuccess: ^(void) {
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         [waitAlert dismissViewControllerAnimated:YES completion:nil];
                                                                         AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                                                                         UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
                                                                         UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
                                                                         appDelegateTemp.window.rootViewController = navigation;
                                                                     });
                                                                     
                                                                 }
                                                                 failure:^(ErrorMessage *error) {
                                                                     UIAlertController *errorLogoutAction = [UIAlertController alertControllerWithTitle:@"Błąd Ń" message:error.errorMessage preferredStyle:UIAlertControllerStyleAlert];
                                                                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                            style:UIAlertActionStyleDefault
                                                                                                                      handler:^(UIAlertAction *action) {}];
                                                                     
                                                                     [errorLogoutAction addAction:okAction];
                                                                     
                                                                     [weakSelf presentViewController:errorLogoutAction animated:YES completion:nil];
                                                                 }];
                                                             }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Nie" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
        
        [alert addAction:logoutAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
//pragma mark - private helpers
-(UIAlertController*)showWaitAlert {
    UIAlertController *waitAlert = [UIAlertController alertControllerWithTitle:@"Wylogowywanie" message:@"Proszę poczekać" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:waitAlert animated:YES completion:nil];
    return waitAlert;
}
@end
