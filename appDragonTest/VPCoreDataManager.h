//
//  VPCoreDataManager.h
//  appDragonTest
//
//  Created by Администратор on 8/19/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (VPCoreDataManager *)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
