//
//  ViewController.h
//  BikeMe
//
//  Created by Krzysztof Maciążek on 19/09/15.
//  Copyright (c) 2015 Kysiek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configuration.h"
#import "ErrorMessage.h"

@interface MainViewController : UIViewController
@property (weak,nonatomic) IBOutlet UIBarButtonItem * barButton;
- (void) showErrorMessage:(ErrorMessage*) errorMessage forViewController: (UIViewController*) viewController;
@end

