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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* accountHistoryArray;
@property (nonatomic, strong) UserManagementService* userService;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation AccountHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userService = [UserManagementService getInstance];
    [self startDownloadingAccountHistoryAndShowTable];
    
    //initializing the refresh controll
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshAccountHistory:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    
    
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
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
            [self reloadTableViewForAccountHistory:[self.userService getAccountHistory]];
        });
        
        
    }
}

- (void)reloadTableViewForAccountHistory: (NSArray*) accountHistoryArray{
    self.accountHistoryArray = accountHistoryArray;
    [self.tableView reloadData];
}
- (void)refreshAccountHistory:(UIRefreshControl *)refreshControl {
    [self startDownloadingAccountHistoryAndShowTable];
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

#pragma mark - Navigation


- (void)startDownloadingAccountHistoryAndShowTable {
    [self.userService loadAccountHistory];
}

@end
