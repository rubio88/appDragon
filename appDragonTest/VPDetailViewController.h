//
//  VPDetailViewController.h
//  appDragonTest
//
//  Created by Администратор on 8/13/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
