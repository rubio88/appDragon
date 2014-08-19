//
//  VPMasterViewController.m
//  appDragonTest
//
//  Created by Администратор on 8/13/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "VPAppDelegate.h"
#import "VPProfileVC.h"
#import "AFNetworking.h"

@interface VPProfileVC ()

@property NSDictionary *profile;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *facebookField;
@property (weak, nonatomic) IBOutlet UITextField *gplusField;
@property (weak, nonatomic) IBOutlet UITextField *youtubeField;

@property (strong, nonatomic) VPNetworkManager *networkManager;

- (IBAction)setAvatar:(id)sender;
@end

@implementation VPProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkManager = [VPNetworkManager new];
    [self getProfileAndAvatar];
}

- (void)viewProfile {
    self.nameField.text = [NSString stringWithFormat:@"%@ %@", self.managedObject.first_name, self.managedObject.last_name];
    self.emailField.text = self.managedObject.email;
    self.facebookField.text = self.managedObject.facebook_url;
    self.gplusField.text = self.managedObject.googleplus_url;
    self.youtubeField.text = self.managedObject.youtube_url;
    
    self.avatarImage.image = [UIImage imageWithData:self.managedObject.image];
}

#pragma mark - Network

- (void)getProfileAndAvatar {
    [self.networkManager getProfileAndAvatarWithID:self.managedObject.user_id succes:^(NSDictionary *result, NSData *image) {
        self.profile = result;
        self.managedObject.image = image;
        [self updateCoreData];
        [self viewProfile];
    }];
}

- (void)sendAvatar {
    [self.networkManager sendAvatar:self.managedObject.image];
}

#pragma mark - coreData

- (void)updateCoreData {
    self.managedObject.first_name = [self.profile objectForKey:@"first_name"];
    self.managedObject.last_name = [self.profile objectForKey:@"last_name"];
    self.managedObject.email = [self.profile objectForKey:@"email"];
    self.managedObject.facebook_url = [self.profile objectForKey:@"facebook_url"];
    self.managedObject.googleplus_url = [self.profile objectForKey:@"googleplus_url"];
    self.managedObject.youtube_url = [self.profile objectForKey:@"youtube_url"];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    NSLog(@"first name: %@", self.managedObject.first_name);
}

#pragma mark - imagePicker

- (IBAction)setAvatar:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:^{}];
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
