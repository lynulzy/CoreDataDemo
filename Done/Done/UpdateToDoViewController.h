//
//  UpdateToDoViewController.h
//  Done
//
//  Created by ZSXJ on 15/1/16.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface UpdateToDoViewController : UIViewController
@property (weak, nonatomic)IBOutlet UITextField *textField;
@property (strong, nonatomic)NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic)NSManagedObject *record;

@end
