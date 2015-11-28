//
//  RootViewController.h
//  GongSuo
//
//  Created by 邓鹏 on 14-6-30.
//  Copyright (c) 2014年 com.kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"

@interface RootViewController : UIViewController<MZTimerLabelDelegate>
{
    
}

- (void)setCountTimes;

@end
