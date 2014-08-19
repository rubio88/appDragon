//
//  VPNetworkManager.h
//  appDragonTest
//
//  Created by Администратор on 8/19/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPNetworkManager : NSObject

@property (strong, nonatomic) NSDictionary *user;

- (void)logInWithEmail:(NSString *)email
           andPassword:(NSString *)password
                succes:(void(^)(NSDictionary *result))resultBlock;
- (void)logOut;
- (void)getProfileAndAvatarWithID:(NSString *)userId
                           succes:(void(^)(NSDictionary *result, NSData *image))resultBlock;
- (void)sendAvatar:(NSData *)avatar;
@end
