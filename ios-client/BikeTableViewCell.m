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
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end