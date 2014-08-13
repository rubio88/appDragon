//
//  VPAppDelegate.h
//  appDragonTest
//
//  Created by Администратор on 8/13/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
