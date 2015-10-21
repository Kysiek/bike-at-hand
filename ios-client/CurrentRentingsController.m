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
@property (nonatomic, strong) UserManagementService* userService;
@end

@implementation CurrentRentingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userService = [UserManagementService getInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
