//
//  UpdateToDoViewController.m
//  Done
//
//  Created by ZSXJ on 15/1/16.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "UpdateToDoViewController.h"

@interface UpdateToDoViewController ()

@end

@implementation UpdateToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.record) {
        [self.textField setText:[self.record valueForKey:@"name"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark Actions
- (IBAction)cancle:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender
{
    NSString *name = self.textField.text;
    if (name&&name.length) {
        //Populate Record
        [self.record setValue:name forKey:@"name"];
        //Save Record
        NSError *error = nil;
        if ([self.managedObjectContext save:&error]) {
            //Pop View Controller
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if (error) {
                NSLog(@"Unable to save record");
                NSLog(@"%@,%@",error,error.localizedDescription);
                
            }
            [[[UIAlertView alloc] initWithTitle:@"Warnning" message:@"Your to-do could not be saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }
    else
    {
        //The name is nil so can't save 
        [[[UIAlertView alloc] initWithTitle:@"Warnning" message:@"Your to-do could not be saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}
@end
