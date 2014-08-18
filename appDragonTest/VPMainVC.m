//
//  VPMasterViewController.m
//  appDragonTest
//
//  Created by Администратор on 8/13/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "VPAppDelegate.h"
#import "VPMainVC.h"
#import "AFNetworking.h"
#import "Profile.h"

@interface VPMainVC ()

@property NSDictionary *user;
@property NSDictionary *profile;

@property (strong, nonatomic) Profile *managedObject;
@property (strong, nonatomic) NSString *baseURL;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *facebookField;
@property (weak, nonatomic) IBOutlet UITextField *gplusField;
@property (weak, nonatomic) IBOutlet UITextField *youtubeField;

- (IBAction)LogIn:(id)sender;
- (IBAction)LogOut:(id)sender;
- (IBAction)setAvatar:(id)sender;
@end

@implementation VPMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.managedObjectContext = [(VPAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.baseURL = @"http://appserver.ambivo.com/";
    [self fetchProfile];
}

- (IBAction)LogIn:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{ @"email" : @"attecus@mail.ru",
                                  @"password" : @"1234567",
                                  @"device_id" : @"1111222244445556",
                                  @"os" : @"iOS",
                                  @"os_version" : @"7" };
    
    [manager POST:[NSString stringWithFormat:@"%@user/login", self.baseURL]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.user = [responseObject objectForKey:@"user"];
        
        if (self.user != nil) {
//             NSLog(@"dict: %@", self.user);
            self.managedObject.user_id = [self.user objectForKey:@"id"];
            [self getProfile];
            [self getAvatar];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)updateCoreData {
    self.managedObject.first_name = [self.profile objectForKey:@"first_name"];
    self.managedObject.last_name = [self.profile objectForKey:@"last_name"];
    self.managedObject.email = [self.profile objectForKey:@"email"];
    self.managedObject.facebook_url = [self.profile objectForKey:@"facebook_url"];
    self.managedObject.googleplus_url = [self.profile objectForKey:@"googleplus_url"];
    self.managedObject.youtube_url = [self.profile objectForKey:@"youtube_url"];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    NSLog(@"first name: %@", self.managedObject.first_name);
}

- (void)viewProfile {
    self.nameField.text = [NSString stringWithFormat:@"%@ %@", self.managedObject.first_name, self.managedObject.last_name];
    self.emailField.text = self.managedObject.email;
    self.facebookField.text = self.managedObject.facebook_url;
    self.gplusField.text = self.managedObject.googleplus_url;
    self.youtubeField.text = self.managedObject.youtube_url;
    
    self.avatarImage.image = [UIImage imageWithData:self.managedObject.image];
}

- (void)fetchProfile {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error: %@", error);
    }
    
    if (fetchedObjects.count < 1) {
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:self.managedObjectContext];
    } else {
        self.managedObject = [fetchedObjects objectAtIndex:0];
    }
}

- (IBAction)LogOut:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@user/logout", self.baseURL]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)setAvatar:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:^{}];
}

- (void)getProfile {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"UserId: %@", [self.user objectForKey:@"id"]);
    NSDictionary *parameters = @{ @"userid" : [self.user objectForKey:@"id"] };
    
    [manager GET:[NSString stringWithFormat:@"%@user/public_profile/?", self.baseURL]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             self.profile = [responseObject objectForKey:@"profile"];
             
             if (self.profile != nil) {
                [self updateCoreData];
             }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getAvatar {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    NSLog(@"UserId: %@", [self.user objectForKey:@"id"]);
    NSDictionary *parameters = @{ @"user_id" : [self.user objectForKey:@"id"] };
    
    [manager GET:[NSString stringWithFormat:@"%@user/get_avatar/?", self.baseURL]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSData *imageData = UIImagePNGRepresentation(responseObject);
            self.managedObject.image = imageData;
             
            [self viewProfile];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)sendAvatar {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"UserId: %@", [self.user objectForKey:@"id"]);
    
    [manager POST:[NSString stringWithFormat:@"%@user/avatar", self.baseURL] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFormData:self.managedObject.image name:@"avatar"];
        [formData appendPartWithFileData:self.managedObject.image name:@"avatar" fileName:@"avatar" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        self.managedObject.image = imageData;
        self.avatarImage.image = image;
        [self sendAvatar];
    }];
}
@end
