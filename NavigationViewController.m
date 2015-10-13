//
//  NavigationViewController.m
//  BikeMe
//
//  Created by Krzysztof Maciążek on 20/09/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "NavigationViewController.h"
#import "SWRevealViewController.h"
#import "UserManagementService.h"
#import "MZFormSheetPresentationController.h"
#import "SignOutViewController.h"

@interface NavigationViewController ()
@property (nonatomic, strong) NSArray *menuWhenUserLogged;
@property (nonatomic, strong) NSArray *menuWhenUserNotLogged;
@property (nonatomic) BOOL userIsLogged;
@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuWhenUserNotLogged = @[@"signInNav",@"mapNav",@"stationNav"];
    self.menuWhenUserLogged = @[@"mapNav",@"stationNav",@"userInfoNav",@"signOutNav"];
    
    self.tableView.separatorColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userSignStateHasChanged:)
                                                 name:UserSignedInNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userSignStateHasChanged:)
                                                 name:UserSignedOutNotification
                                               object:nil];
    
    _userIsLogged = [[UserManagementService getInstance] isUserSignedId];
    
    [[MZFormSheetPresentationController appearance] setShouldApplyBackgroundBlurEffect:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_userIsLogged) {
        return [self.menuWhenUserLogged count];
    }
    return [self.menuWhenUserNotLogged count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *menu = _userIsLogged ? self.menuWhenUserLogged : self.menuWhenUserNotLogged;
    NSString* cellIdentifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if( sourceIndexPath.section != proposedDestinationIndexPath.section )
        return sourceIndexPath;
    else
        return proposedDestinationIndexPath;
}
#pragma mark - Sign in state

- (void)userSignStateHasChanged:(NSNotification *) notification {
    if ([[notification name] isEqualToString:UserSignedInNotification]) {
        [self reloadViewForUserSignIn:YES];
    } else if ([[notification name] isEqualToString:UserSignedOutNotification]) {
        [self reloadViewForUserSignIn:NO];
    }
}
- (void) reloadViewForUserSignIn:(BOOL) isSignIn {
    _userIsLogged = isSignIn;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - SignOut delegate
- (void) signOutProcessComplete {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [segue isKindOfClass:[SWRevealViewControllerSegue class]]) {
        SWRevealViewControllerSegue* swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController *svc, UIViewController* dvc) {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers:@[dvc] animated:NO];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        };
    } else if([segue.identifier isEqualToString:@"signOutPopupSegue"]) {
        SignOutViewController *signOutVC = (SignOutViewController*) segue.destinationViewController;
        signOutVC.delegate = self;
    }
}
-(void) dealloc {
    //Removing observer - we need to do it otherwise there will be exception when property would be changed and this instance would not exist
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
