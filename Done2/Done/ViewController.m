//
//  ViewController.m
//  Done
//
//  Created by ZSXJ on 15/1/16.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "ViewController.h"
#import "ToDoCell.h"
#import "AddToDoViewController.h"
#import "UpdateToDoViewController.h"
@interface ViewController ()<NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchResultsController;
//Indicate that which cell is selected
@property (strong, nonatomic) NSIndexPath *selection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"managedObjectContext  %@",self.managedObejctContext);
    //Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
    //Add Sort Descriptor
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]];
    //Initialize Fetch Request Controller
    self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                      managedObjectContext:self.managedObejctContext
                                                                        sectionNameKeyPath:nil cacheName:nil];
    //Configure Fetched Results Controller
    [self.fetchResultsController setDelegate:self];
    
    //Perform Fetch
    NSError *error = nil;
    [self.fetchResultsController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch");
        NSLog(@"%@,%@",error,error.localizedDescription);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellName = @"toDoCell";
//    ToDoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
//    if (!cell) {
//        cell = [[ToDoCell alloc] init];
//    }
//    return cell;
    ToDoCell *cell = (ToDoCell *)[tableView dequeueReusableCellWithIdentifier:@"toDoCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchResultsController sections] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
//Selected some rows
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Store selection
    [self setSelection:indexPath];
}
//Delete some row
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//Edit some row
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *record = [self.fetchResultsController objectAtIndexPath:indexPath];
        if (record) {
            [self.fetchResultsController.managedObjectContext deleteObject:record];
        }
    }
    
}
#pragma mark Fetched Results Controller Delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
            
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
            
        
        case NSFetchedResultsChangeMove:
        {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [self configureCell:(ToDoCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        default:
            break;
    }
}
#pragma mark  A Method To Build A Cell
- (void)configureCell:(ToDoCell *)cell atIndexPath:(NSIndexPath *)theIndexPath
{
    //Fetch a Record
    NSManagedObject *record = [self.fetchResultsController objectAtIndexPath:theIndexPath];
    //Update Cell
    [cell.nameLabel setText:[record valueForKey:@"name"]];
    [cell.doneButton setSelected:[[record valueForKey:@"done"] boolValue]];
    [cell setDidTapButton:^{
        BOOL isDone = [[record valueForKey:@"done"] boolValue];
        //Update Record
        [record setValue:@(!isDone) forKey:@"done"];
                        }];
}
// View controllers will receive this message during segue unwinding. The default implementation returns the result of -respondsToSelector: - controllers can override this to perform any ancillary checks, if necessary.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addToDoViewController"]) {
        //Obtain Reference to View Controller
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        AddToDoViewController *vc = (AddToDoViewController *)[nc topViewController];
        
        [vc setManagedObjectContext:self.managedObejctContext];
    }
    if ([segue.identifier isEqualToString:@"updateToDoViewController"]) {
        UpdateToDoViewController *vc = (UpdateToDoViewController *)[segue destinationViewController];
        //Configure View Controller
        [vc setManagedObjectContext:self.managedObejctContext];
        if (self.selection) {
            //Fetch Record
            NSManagedObject *record = [self.fetchResultsController objectAtIndexPath:self.selection];
            if (record) {
                [vc setRecord:record];
            }
            //Reset Selection
            [self setSelection:nil];
        }
    }
    
}
@end
