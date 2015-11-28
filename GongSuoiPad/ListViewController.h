//
//  ListViewController.h
//  GongSuo
//
//  Created by 邓鹏 on 14/9/7.
//  Copyright (c) 2014年 com.kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface ListViewController : UIViewController

@property (nonatomic, weak)RootViewController *root;

- (void)reloadTableViewData;

@end
