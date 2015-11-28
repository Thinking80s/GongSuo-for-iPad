//
//  TimeTableViewCell.m
//  GongSuo
//
//  Created by 邓鹏 on 14/10/7.
//  Copyright (c) 2014年 com.kevin. All rights reserved.
//

#import "TimeTableViewCell.h"
#import "MZTimerLabel.h"

@implementation TimeTableViewCell{

}

@synthesize startLabel, persisLabel, gapLabel, endLabel;
@synthesize startVal, persisVal, gapVal, endVal;
@synthesize startValTimer, persisValTimer, gapValTimer, endValTimer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self createTitleLabel];
    }
    return self;
}

- (void)createTitleLabel{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    float width = rect.size.width/4;
    
    startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    [startLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    startLabel.textAlignment = NSTextAlignmentCenter;
    //[startLabel setTextColor:[UIColor grayColor]];
    
    endLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 0, width, 30)];
    [endLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    endLabel.textAlignment = NSTextAlignmentCenter;
    //[endLabel setTextColor:[UIColor grayColor]];
    
    persisLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*2, 0, width, 30)];
    [persisLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    persisLabel.textAlignment = NSTextAlignmentCenter;
    //[persisLabel setTextColor:[UIColor grayColor]];
    
    gapLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*3, 0, width, 30)];
    [gapLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    gapLabel.textAlignment = NSTextAlignmentCenter;
    //[gapLabel setTextColor:[UIColor grayColor]];
    
    [self.contentView addSubview:startLabel];
    [self.contentView addSubview:persisLabel];
    [self.contentView addSubview:gapLabel];
    [self.contentView addSubview:endLabel];
    
    startVal = [[UILabel alloc] initWithFrame:CGRectMake(4, 20, width, 30)];
    [startVal setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18]];
    startVal.textAlignment = NSTextAlignmentCenter;
    startValTimer = [[MZTimerLabel alloc] initWithLabel:startVal];
    [startValTimer setCountDownTime:0];
    startValTimer.timeFormat = @"hh:mm:ss";
    
    endVal = [[UILabel alloc] initWithFrame:CGRectMake(width + 4, 20, width, 30)];
    [endVal setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18]];
    endVal.textAlignment = NSTextAlignmentCenter;
    endValTimer = [[MZTimerLabel alloc] initWithLabel:endVal];
    [endValTimer setCountDownTime:0];
    endValTimer.timeFormat = @"hh:mm:ss";
    
    persisVal = [[UILabel alloc] initWithFrame:CGRectMake(width*2, 20, width, 30)];
    [persisVal setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18]];
    persisVal.textAlignment = NSTextAlignmentCenter;
    persisValTimer = [[MZTimerLabel alloc] initWithLabel:persisVal andTimerType:MZTimerLabelTypeStopWatch];
    [persisValTimer setStopWatchTime:0];
    persisValTimer.timeFormat = @"mm:ss";
    
    gapVal = [[UILabel alloc] initWithFrame:CGRectMake(width*3, 20, width, 30)];
    [gapVal setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
    gapVal.textAlignment = NSTextAlignmentCenter;
    gapValTimer = [[MZTimerLabel alloc] initWithLabel:gapVal andTimerType:MZTimerLabelTypeStopWatch];
    [gapValTimer setStopWatchTime:0];
    gapValTimer.timeFormat = @"mm:ss";
    
    [self.contentView addSubview:startVal];
    [self.contentView addSubview:persisVal];
    [self.contentView addSubview:gapVal];
    [self.contentView addSubview:endVal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
