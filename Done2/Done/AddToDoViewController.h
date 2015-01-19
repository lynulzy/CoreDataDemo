//
//  AddToDoViewController.h
//  Done
//
//  Created by ZSXJ on 15/1/16.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddToDoViewController : UIViewController<UITextFieldDelegate>

@property (weak ,nonatomic)IBOutlet UITextField *textField;

@property (strong ,nonatomic)NSManagedObjectContext *managedObjectContext;
@end
