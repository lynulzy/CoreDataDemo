//
//  ToDoCell.m
//  Done
//
//  Created by ZSXJ on 15/1/16.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "ToDoCell.h"


@implementation ToDoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setupView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupView
{
    UIImage *imageNormal = [UIImage imageNamed:@"button-done-normal"];
    UIImage *imageSelected = [UIImage imageNamed:@"button-done-selected"];
    
    [self.doneButton setImage:imageNormal forState:UIControlStateNormal];
    [self.doneButton setImage:imageNormal forState:UIControlStateDisabled];
    [self.doneButton setImage:imageSelected forState:UIControlStateSelected];
    [self.doneButton setImage:imageSelected forState:UIControlStateHighlighted];
    [self.doneButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)buttonClicked:(UIButton *)btn
{
    if (self.didTapButton) {
        self.didTapButton();
    }
}
@end
