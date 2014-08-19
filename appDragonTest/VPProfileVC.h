//
//  VPMasterViewController.h
//  appDragonTest
//
//  Created by Администратор on 8/13/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Profile.h"

@interface VPProfileVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Profile *managedObject;

@end
