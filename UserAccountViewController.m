//
//  UserAccountViewController.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 26/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "UserAccountViewController.h"
#import "AccountHistory.h"
#import "AccountHistoryCellViewTableViewCell.h"
#import "UserManagementService.h"

@interface UserAccountViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* accountHistoryArray;
@property (nonatomic, strong) UserManagementService* userService;
@end

@implementation UserAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barButton.title = userAccountInfoViewControllerTitle;
    self.userService = [UserManagementService getInstance];
    [self.userService loadAccountHistory ];
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                               selector:@selector(receivedNotification:)
                                                   name:UserHistoryAccountArrived
                                                 object:nil];
    // Do any additional setup after loading the view.
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
static NSString* CellID = @"accountHistoryCell";

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    AccountHistory* accountHistory = self.accountHistoryArray[row];
    AccountHistoryCellViewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellID];
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

@end
