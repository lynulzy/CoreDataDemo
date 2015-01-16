//
//  ToDoCell.h
//  Done
//
//  Created by ZSXJ on 15/1/16.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ToDoCellClickedBlock)();

@interface ToDoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (copy, nonatomic) ToDoCellClickedBlock didTapButton;
@end
