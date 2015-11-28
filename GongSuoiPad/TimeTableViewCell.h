//
//  TimeTableViewCell.h
//  GongSuo
//
//  Created by 邓鹏 on 14/10/7.
//  Copyright (c) 2014年 com.kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"

@interface TimeTableViewCell : UITableViewCell{
    UILabel *startLabel;
    UILabel *persisLabel;
    UILabel *gapLabel;
    UILabel *endLabel;
    
    UILabel *startVal;
    UILabel *persisVal;
    UILabel *gapVal;
    UILabel *endVal;

    MZTimerLabel *startValTimer;
    MZTimerLabel *persisValTimer;
    MZTimerLabel *gapValTimer;
    MZTimerLabel *endValTimer;
}

@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *persisLabel;
@property (nonatomic, strong) UILabel *gapLabel;
@property (nonatomic, strong) UILabel *endLabel;

@property (nonatomic, strong) UILabel *startVal;
@property (nonatomic, strong) UILabel *persisVal;
@property (nonatomic, strong) UILabel *gapVal;
@property (nonatomic, strong) UILabel *endVal;

@property (nonatomic, strong) MZTimerLabel *startValTimer;
@property (nonatomic, strong) MZTimerLabel *persisValTimer;
@property (nonatomic, strong) MZTimerLabel *gapValTimer;
@property (nonatomic, strong) MZTimerLabel *endValTimer;

@end
