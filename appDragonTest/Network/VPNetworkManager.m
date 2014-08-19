//
//  VPNetworkManager.m
//  appDragonTest
//
//  Created by Администратор on 8/19/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "VPNetworkManager.h"
#import "AFNetworking.h"

@implementation VPNetworkManager

- (void)logInWithEmail:(NSString *)email
           andPassword:(NSString *)password
                succes:(void(^)(NSDictionary *result))resultBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{ @"email" : email,
                                  @"password" : password,
                                  @"device_id" : DEVICE_ID,
                                  @"os" : USER_OS,
                                  @"os_version" : OS_VERSION };
    
    [manager POST:[NSString stringWithFormat:@"%@user/login", BASE_URL]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              self.user = [responseObject objectForKey:@"user"];
              
              if (self.user != nil) {
                  resultBlock(self.user);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)logOut {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@user/logout", BASE_URL]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)getProfileAndAvatarWithID:(NSString *)userId
                  succes:(void(^)(NSDictionary *result, NSData *image))resultBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"UserId: %@", userId);
    NSDictionary *parameters;
    if (userId != nil) {
        parameters = @{ @"userid" : userId };
    }
    
    // Get profile, after that get avatar and return them with block
    
    [manager GET:[NSString stringWithFormat:@"%@user/public_profile/?", BASE_URL]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             
             if ([responseObject objectForKey:@"profile"] != nil) {
                 [self getAvatarWithID:userId succes:^(NSData *image) {
                     resultBlock([responseObject objectForKey:@"profile"], image);
                 }];
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (void)getAvatarWithID:(NSString *)userId
                 succes:(void(^)(NSData *image))resultBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    NSDictionary *parameters;
    if (userId != nil) {
        parameters = @{ @"user_id" : userId };
    }
    
    [manager GET:[NSString stringWithFormat:@"%@user/get_avatar/?", BASE_URL]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             NSData *imageData = UIImagePNGRepresentation(responseObject);
             resultBlock(imageData);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (void)sendAvatar:(NSData *)avatar {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:[NSString stringWithFormat:@"%@user/avatar", BASE_URL] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:avatar name:@"avatar" fileName:@"avatar" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
