//
//  AccountHistoryViewController.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 18/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "AccountHistoryViewController.h"
#import "AccountHistory.h"
#import "AccountHistoryTableViewCell.h"
#import "UserManagementService.h"

@interface AccountHistoryViewController ()
@property (weak, nonatomic) IBOutlet UIView *logOutStateView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* accountHistoryArray;
@property (nonatomic, strong) UserManagementService* userService;
@end

@implementation AccountHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userService = [UserManagementService getInstance];
    if([self.userService isUserSignedId]) {
        [self startDownloadingAccountHistoryAndShowTable];
    }
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(receivedNotification:)
                                                  name:UserHistoryAccountArrived
                                                object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receivedNotification:(NSNotification*) notification {
    if([[notification name] isEqualToString:UserHistoryAccountArrived]) {
        [self reloadTableViewForAccountHistory:[self.userService getAccountHistory]];
    }
}

- (void)reloadTableViewForAccountHistory: (NSArray*) accountHistoryArray{
    self.accountHistoryArray = accountHistoryArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark - UITableViewDataSource
static NSString* CellID = @"accountHistoryCell";

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    AccountHistory* accountHistory = self.accountHistoryArray[row];
    AccountHistoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setLabels:accountHistory];
    return cell;
}
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.accountHistoryArray) {
        return self.accountHistoryArray.count;
    }
    return 0;
}
#pragma mark - SignInViewControllerDelegate

- (void)signInControllerFinished:(NSString *) signInMessage {
    if([signInMessage isEqualToString:LoginSuccessNotification]) {
        [self startDownloadingAccountHistoryAndShowTable];
    } else {
        
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

- (void)startDownloadingAccountHistoryAndShowTable {
    self.logOutStateView.hidden = YES;
    self.tableView.hidden = NO;
    [self.userService loadAccountHistory];
}

@end
