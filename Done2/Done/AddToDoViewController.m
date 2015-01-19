//
//  AddToDoViewController.m
//  Done
//
//  Created by ZSXJ on 15/1/16.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "AddToDoViewController.h"
#import <CoreData/CoreData.h>
@interface AddToDoViewController ()

@end

@implementation AddToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
#pragma mark Action
- (IBAction)cancle:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save:(id)sender
{
    NSString *name = [self.textField text];
    if (name && name.length) {
        //Create a Entity
        NSEntityDescription *description = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        //Initialize Record
        NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
        
        //Populate the Record
        [record setValue:name forKey:@"name"];
        [record setValue:[NSDate date] forKey:@"createdAt"];
        //Save Record
        NSError *error = nil;
        if ([self.managedObjectContext save:&error])
        {
            // Dismiss View Controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        else
        {
            if (error) {
                NSLog(@"Unable to save record.");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
            
            // Show Alert View
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    }
    //There is no avaliable "name"
    else {
        // Show Alert View
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do needs a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}
@end
