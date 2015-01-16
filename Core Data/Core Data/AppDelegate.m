//
//  AppDelegate.m
//  Core Data
//
//  Created by ZSXJ on 15/1/15.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //Create Managed Object
        //Person
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *newPerson = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    [newPerson setValue:@"ZhiYuan" forKey:@"first"];
    [newPerson setValue:@"Li" forKey:@"last"];
    [newPerson setValue:@23 forKey:@"age"];
    
    NSError *error;
    if (![newPerson.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context");
        NSLog(@"%@,%@",error,error.localizedDescription);
    }
        //Adress
    NSEntityDescription *adressDescription = [NSEntityDescription entityForName:@"Adress" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *newAdress = [[NSManagedObject alloc] initWithEntity:adressDescription insertIntoManagedObjectContext:self.managedObjectContext];
    [newAdress setValue:@"MainStreet" forKey:@"street"];
    [newAdress setValue:@"Beijing" forKey:@"city"];
    //Create relationship
        //Add a Adress for a Person
    [newPerson setValue:[NSSet setWithObjects:newAdress, nil] forKey:@"adresses"];
    error = nil;
    if (![newPerson.managedObjectContext save:&error]) {
        NSLog(@"Unable to save a managed object context add a person an adress");
        NSLog(@"%@,%@",error,error.localizedDescription);
    }
        //Add a new Adress for a Person
    NSManagedObject *otherAdress = [[NSManagedObject alloc] initWithEntity:adressDescription insertIntoManagedObjectContext:self.managedObjectContext];
    [otherAdress setValue:@"5th Avenue" forKey:@"street"];
    [otherAdress setValue:@"New York" forKey:@"city"];
    
        //When we use this kind of way to update a attribute of an entity don't need to call "save" method to save the context changed because Cord Data can help us monitor the record;
    NSMutableSet *adresses = [newPerson mutableSetValueForKey:@"adresses"];
    [adresses addObject:otherAdress];
    //Delete relationship
        //send a 'nil' to the relationship
    [newPerson setValue:nil forKey:@"adresses"];
        //Create another Person
    NSManagedObject *anotherPerson = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    [anotherPerson setValue:@"Jane" forKey:@"first"];
    [anotherPerson setValue:@"Doe" forKey:@"last"];
    [anotherPerson setValue:@22 forKey:@"age"];
    //Create Relationship
    [newPerson setValue:anotherPerson forKey:@"spouse"];
        //Create a child Person
    NSManagedObject *aChildPerson = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    [aChildPerson setValue:@"Jim" forKey:@"first"];
    [aChildPerson setValue:@"Doe" forKey:@"last"];
    [aChildPerson setValue:@10 forKey:@"age"];
        //Create the relationship with 'newPerson'
    NSMutableSet *children = [newPerson mutableSetValueForKey:@"children"];
    [children addObject:aChildPerson];
    //Create another Child
    NSManagedObject *anotherChildPerson = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    [anotherChildPerson setValue:@"Lucy" forKey:@"first"];
    [anotherChildPerson setValue:@"Doe" forKey:@"last"];
    [anotherChildPerson setValue:@12 forKey:@"age"];
    
    //relationship
    [anotherPerson setValue:newPerson forKey:@"father"];
    
    //Fetch Records
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescriptionFetched = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDescriptionFetched];
    error = nil;
    NSArray *resultArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Unable to execute fetch request");
        NSLog(@"%@,%@",error,error.localizedDescription);
    }
    else{
        if (0 < resultArr.count) {
            NSManagedObject *person = (NSManagedObject *)resultArr[0];
            NSLog(@"1 - %@", person);
            NSLog(@"%@ %@", [person valueForKey:@"first"], [person valueForKey:@"last"]);
            NSLog(@"2 - %@", person);
        }
    }
    //Update a record
    /*
     1.fetch a record
     2.change the attrinbute of the record
     3.save the record
     */
    NSManagedObject *editPerson = (NSManagedObject *)resultArr[0];
    [editPerson setValue:@24 forKey:@"age"];
    NSError *updateErr;
    if (![editPerson.managedObjectContext save:&updateErr]) {
        NSLog(@"Unable to update the record");
        NSLog(@"%@,%@",updateErr,updateErr.localizedDescription);
    }
    //Delete a record
    /*
     1.finger out the record u want to delete;
     2.call the method "deleteObject:"
     3.managed object context should call save method to execute the operation before (delete a record)
     */
    NSManagedObject *person_del = (NSManagedObject *)resultArr[0];
    
    [self.managedObjectContext deleteObject:person_del];
    
    NSError *deleteErr;
    if (![person_del.managedObjectContext save:&deleteErr]) {
        NSLog(@"Unable to Delete the record");
        NSLog(@"%@,%@",deleteErr,deleteErr.localizedDescription);
    }
    /* Fetch and Sort*/
    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    //Add sort Descriptor
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"first" ascending:YES];
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"last" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
        //We can send a array of Descriptor
    [fetchRequest2 setSortDescriptors:@[sortDescriptor,sortDescriptor1,sortDescriptor2]];
    error = nil;
    //fetchRequest
    NSArray *result2 = [self.managedObjectContext executeFetchRequest:fetchRequest2 error:&error];
    if (error) {
        NSLog(@"Unable to Fetch data");
        NSLog(@"%@,%@",error,error.localizedDescription);
        
    }
    else
    {
        for (NSManagedObject *obj in result2) {
            NSLog(@"%@,%@ - %@",[obj valueForKey:@"first"],[obj valueForKey:@"last"],[obj valueForKey:@"age"]);
        }
    }
    //Using 'Predicates' will improve the performance when searching some results
    NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    //Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"last",@"Doe"];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%K >= %@",@"age",@"20"];
    
    [fetchRequest3 setPropertiesToFetch:@[predicate,predicate2]];
    //Add sort descriptor
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"last" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor3,sortDescriptor4]];
    //Fetch Request.
    error = nil;
    NSArray *result3 = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        for (NSManagedObject *obj in result3) {
            NSLog(@"%@~~%@",[obj valueForKey:@"first"],[obj valueForKey:@"last"]);
            
        }
    }
    else
    {
        NSLog(@"Unable to fetch data  fetchRequest3");
        NSLog(@"%@,%@",error,error.localizedDescription);
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ZSXJ.Core_Data" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Core_Data" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Data.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
