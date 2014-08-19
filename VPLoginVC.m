//
//  VPLoginVC.m
//  appDragonTest
//
//  Created by Администратор on 8/18/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "VPAppDelegate.h"
#import "VPLoginVC.h"
#import "VPProfileVC.h"
#import "Profile.h"

@interface VPLoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Profile *managedObject;
@property (strong, nonatomic) VPNetworkManager *networkManager;

- (IBAction)LogIn:(id)sender;
- (IBAction)LogOut:(id)sender;
@end

@implementation VPLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkManager = [VPNetworkManager new];
    [self fetchFromCoreData];
}

- (void)fetchFromCoreData {
    self.managedObjectContext = [[VPCoreDataManager sharedInstance] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error: %@", error);
    }
    
    if (fetchedObjects.count > 0) {
        self.managedObject = fetchedObjects[0];
    } else {
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:self.managedObjectContext];
    }
}

- (IBAction)LogIn:(id)sender {
    [self.networkManager logInWithEmail:self.loginTextField.text andPassword:self.passwordTextField.text succes:^(NSDictionary *result) {
        if (result != nil) {
            //NSLog(@"dict: %@", result);
            self.managedObject.user_id = [result objectForKey:@"id"];
            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            [self performSegueWithIdentifier:@"profileSegue" sender:nil];
        }
    }];
}

- (IBAction)LogOut:(id)sender {
    [self.networkManager logOut];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"profileSegue"]) {
        VPProfileVC *profileVC = [segue destinationViewController];
        profileVC.managedObjectContext = self.managedObjectContext;
        profileVC.managedObject = self.managedObject;
    }
}
@end
