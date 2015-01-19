//
//  AppDelegate.m
//  Done
//
//  Created by ZSXJ on 15/1/16.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
//@synthesize managedObjectContext;
//@synthesize persistentStoreCoordinator;
//@synthesize managedOjbectModel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Use StoryBoard
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //Instantiate Root Navgation Controller
    UINavigationController *rootNavgationController = (UINavigationController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"rootNavgationController"];
    ViewController *viewController = (ViewController *)[rootNavgationController topViewController];
    if ([viewController isKindOfClass:[viewController class]]) {
        [viewController setManagedObejctContext:self.managedObjectContext];
    }
    //Set RootViewController of Window
    [self.window setRootViewController:rootNavgationController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        if (error) {
            NSLog(@"Unable to save changes");
            NSLog(@"%@,%@",error,error.localizedDescription);
        }
    }
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
    //Force quit by user;
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        if (error) {
            NSLog(@"Unable to save changes");
            NSLog(@"%@,%@",error,error.localizedDescription);
        }
    }
}

#pragma mark Core Data Stack
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}
- (NSManagedObjectModel *)managedOjbectModel
{
    if (_managedOjbectModel) {
        return _managedOjbectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Done" withExtension:@"momd"];
    _managedOjbectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedOjbectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"Store.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedOjbectModel]];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),NSInferMappingModelAutomaticallyOption:@(YES)};
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"error when create the PersistenmCoordinator %@:%@",error,error.localizedDescription);
//        abort();
        NSFileManager *fm = [NSFileManager defaultManager];
        //Move Incompatible Store
        if ([fm fileExistsAtPath:[storeURL path]]) {
            NSURL *corruptURL = [[self applicationIncompatibleStoresDiectory] URLByAppendingPathComponent:[self nameForIncompatibleStores]];
            //Move corrupt store
            NSError *moveError = nil;
            [fm moveItemAtURL:storeURL toURL:corruptURL error:&moveError];
            if (error) {
                NSLog(@"Unable move to corrupt store.");
            }
        }
        
    }
    NSError *errorAddingStore = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unable to create persistent store after recovery .%@,%@",errorAddingStore,errorAddingStore.localizedDescription);
        //Show alert view
        NSString *title = @"Warnning";
        NSString *applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        NSString *message = [NSString stringWithFormat:@"A serious application error occurred while %@ tried to read your data,",applicationName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    return _persistentStoreCoordinator;
}

- (void)saveManagedObjectContext{
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        if (error) {
            NSLog(@"Unable to save Managed Object Context");
            NSLog(@"%@,%@",error,error.localizedDescription);
        }
    }
    
}

- (NSURL *)applicationStoresDirectory
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *applicationApplicationSupportDirectory = [[fm URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *url = [applicationApplicationSupportDirectory URLByAppendingPathComponent:@"Stores"];
    if (![fm fileExistsAtPath:[url path]]) {
        NSError *error = nil;
        [fm createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"Unable to create directory for data stores");
            return nil;
        }
    }
    return url;
}

- (NSURL *)applicationIncompatibleStoresDiectory{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *url = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"Incompatible"];
    if (![fm fileExistsAtPath:[url path]]) {
        NSError *error = nil;
        [fm createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"Unable to create directory for incompatible data stores");
            return nil;
        }
    }
    return url;
}

- (NSString *)nameForIncompatibleStores
{
    //Initialize date formmater
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //Configure Date formater
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    return [NSString stringWithFormat:@"%@.sqlite",[dateFormatter stringFromDate:[NSDate date]]];
    
}



@end
