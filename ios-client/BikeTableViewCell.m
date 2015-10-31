//
//  BikeTableViewCell.m
//  bike@hand
//
//  Created by Krzysztof Maciążek on 20/10/15.
//  Copyright © 2015 Kysiek. All rights reserved.
//

#import "BikeTableViewCell.h"

@interface BikeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *bikeNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end
@implementation BikeTableViewCell

- (void)setData:(NSNumber *)bikeNumber {
    self.bikeNumberLabel.text = [NSString stringWithFormat:@"Numer roweru: %@", bikeNumber];
    [self.actionButton setTitle:@"Wypożycz" forState:UIControlStateNormal];
}
- (IBAction)didTapActionButton:(id)sender {
    NSString* title = [self.actionButton titleLabel].text;
    if([title isEqualToString:@"Wypożycz"]) {
        [self.actionButton setTitle:@"Zwolnij" forState:UIControlStateNormal];
    } else if ([title isEqualToString:@"Zwolnij"]) {
        [self.actionButton setTitle:@"Zwróć" forState:UIControlStateNormal];
    } else if ([title isEqualToString:@"Zwróć"]) {
       [self.actionButton setTitle:@"Wypożycz" forState:UIControlStateNormal];
    }
}
- (void)awakeFromNib {
    self.actionButton.layer.borderWidth = 1.0;
    self.actionButton.layer.borderColor = [[UIColor blueColor] CGColor];
    self.actionButton.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end