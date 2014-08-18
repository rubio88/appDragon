//
//  Profile.h
//  appDragonTest
//
//  Created by Администратор on 8/15/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Profile : NSManagedObject

@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * facebook_url;
@property (nonatomic, retain) NSString * googleplus_url;
@property (nonatomic, retain) NSString * youtube_url;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSData * image;

@end
