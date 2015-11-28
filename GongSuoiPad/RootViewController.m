//
//  RootViewController.m
//  GongSuo
//
//  Created by 邓鹏 on 14-6-30.
//  Copyright (c) 2014年 com.kevin. All rights reserved.
//

#import "RootViewController.h"
#import "MZTimerLabel.h"
#import "ListViewController.h"
#import "DetailViewController.h"
#import "HistoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FRDLivelyButton.h"
#import "TimeData.h"

@interface RootViewController () <UIAlertViewDelegate, UIActionSheetDelegate>
{
    ListViewController *list;
    CAShapeLayer *rotateLayer;
    MZTimerLabel *mainTimer;
    MZTimerLabel *continueTimer;
    MZTimerLabel *gapTimer;
    UILabel *mainTimeLabel;
    UILabel *continueLabel;
    UILabel *gapLabel;
    UILabel *countTitle;
    UILabel *historyLabel;
    UIButton *button;
    BOOL isStart;
    UIWebView *phoneCallWebView;
    NSDate *startDate;
    NSDate *stopDate;
    NSTimer *startListenTime;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [TimeData initData];
    [self createCycleBackground];
    [self createDisplayLabel];
    [self createStartEndButton];
    [self createDetailButton];
    [self createHistoryButton];
    //[self createTelphoneButton];
    [self createSplitLine];
    [self createListGrid];
    [self setCountTimes];
    [self startListenTime];
    //[[ UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)createListGrid{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    list = [[ListViewController alloc] init];
    list.root = self;
    [list.view setFrame:CGRectMake(0, rect.size.height/2 + 141, rect.size.width, rect.size.height - (rect.size.height/2 + 120))];
    [self.view addSubview:list.view];
}

- (void)createStartEndButton{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    float width = rect.size.width/3;
    
    //点击按钮
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 95, 40)];
    button.center = CGPointMake(rect.size.width/2,rect.size.height/3.3 + 35);
    [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20.0]];
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 5.0;
    [button setTitle:NSLocalizedString(@"start", nil) forState:UIControlStateNormal];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(timerStartStop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //主显时间
    mainTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 190, 70)];
    [mainTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:60.0]];
    mainTimeLabel.textAlignment = NSTextAlignmentCenter;
    mainTimeLabel.center = CGPointMake(rect.size.width/2,rect.size.height/4.5 + 25);
    [self.view addSubview:mainTimeLabel];
    mainTimer = [[MZTimerLabel alloc] initWithLabel:mainTimeLabel];
    [mainTimer setCountDownTime:0];
    mainTimer.timeFormat = @"mm:ss";
    
    //平均持续
    continueLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, rect.size.height/2 + 105, width, 30)];
    [continueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:28.0]];
    continueLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:continueLabel];
    continueTimer = [[MZTimerLabel alloc] initWithLabel:continueLabel andTimerType:MZTimerLabelTypeStopWatch];
    [continueTimer setStopWatchTime:0];
    continueTimer.timeFormat = @"mm:ss";
    
    //平均间隔
    gapLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*2, rect.size.height/2 + 105, width, 30)];
    [gapLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:28.0]];
    gapLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:gapLabel];
    gapTimer = [[MZTimerLabel alloc] initWithLabel:gapLabel andTimerType:MZTimerLabelTypeStopWatch];
    [gapTimer setStopWatchTime:0];
    gapTimer.timeFormat = @"mm:ss";
}

- (void)createSplitLine{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    float width = rect.size.width / 3;
    
    UIImageView *topSplit = [[UIImageView alloc] initWithImage:[self createImageWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f] customRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)]];
    [topSplit setFrame:CGRectMake(0, rect.size.height/2 + 73, rect.size.width, 1)];
    [self.view addSubview:topSplit];
    
    UIImageView *bottomSplit = [[UIImageView alloc] initWithImage:[self createImageWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f] customRect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)]];
    [bottomSplit setFrame:CGRectMake(0, rect.size.height/2 + 140, rect.size.width, 1)];
    [self.view addSubview:bottomSplit];

    UIImageView *leftSplit = [[UIImageView alloc] initWithImage:[self createImageWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f] customRect:CGRectMake(0.0f, 0.0f, 1.0f, 67.0f)]];
    [leftSplit setFrame:CGRectMake(width, rect.size.height/2 + 73, 1, 67)];
    [self.view addSubview:leftSplit];
    
    UIImageView *rightSplit = [[UIImageView alloc] initWithImage:[self createImageWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f] customRect:CGRectMake(0.0f, 0.0f, 1.0f, 67.0f)]];
    [rightSplit setFrame:CGRectMake(width*2, rect.size.height/2 + 73, 1, 67)];
    [self.view addSubview:rightSplit];
}

- (UIImage*)createImageWithColor:(UIColor*)color customRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)createDetailButton{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [detailButton setFrame:CGRectMake(rect.size.width - 35, 25, 25, 25)];
    [detailButton addTarget:self action:@selector(detailInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailButton];
}

- (void)createHistoryButton{
    FRDLivelyButton *_button = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(15, 25, 20, 20)];
    [_button setOptions:@{ kFRDLivelyButtonLineWidth: @(1.0f),
                          kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                          kFRDLivelyButtonColor: [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]
                          }];
    [_button setStyle:kFRDLivelyButtonStyleHamburger animated:NO];
    [_button addTarget:self action:@selector(historyInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)createTelphoneButton{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    UIButton *telphoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [telphoneButton setFrame:CGRectMake(0, 0, 28, 28)];
    [telphoneButton setCenter:CGPointMake(30, 30)];
    [telphoneButton setBackgroundImage:[UIImage imageNamed:@"phoneButton"] forState:UIControlStateNormal];
    [telphoneButton addTarget:self action:@selector(telphoneInfo) forControlEvents:UIControlEventTouchUpInside];

    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(38, rect.size.height/3.5 - 80, 60, 60)];
    bg.layer.cornerRadius = 30;
    bg.layer.masksToBounds = YES;
    [bg.layer setShadowOffset:CGSizeMake(0, 0)];
    [bg.layer setShadowColor:[[UIColor grayColor] CGColor]];
    [bg.layer setShadowOpacity:1.0f];
    [bg.layer setBorderColor:[[UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1] CGColor]];
    [bg.layer setBorderWidth:1.0f];
    [bg addSubview:telphoneButton];
    [self.view addSubview:bg];
}

- (void)timerStartStop{
    if(isStart){
        [mainTimer pause];
        [mainTimer reset];
        [self deleteAnimationLayer];
        stopDate = [NSDate date];
        if ([self isCreateStop]) {
            [self createRecordData];
        }
        isStart = false;
        [button setTitle:NSLocalizedString(@"start", nil) forState:UIControlStateNormal];
    }else{
        startDate = [NSDate date];
        if([self isCreateStart]){
            [mainTimer reset];
            [mainTimer start];
            isStart = true;
            [button setTitle:NSLocalizedString(@"stop", nil) forState:UIControlStateNormal];
        }
    }
}

- (void)startListenTime{
    startListenTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                selector:@selector(startListenTimeHander)  userInfo:nil repeats:YES];
}

- (void)startListenTimeHander{
    if (isStart) {
        double time = [[NSDate date] timeIntervalSinceDate:startDate];
        if (time > 5*60) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"moreThan5min", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"know", nil)otherButtonTitles:nil, nil];
            [alert show];
            [self timerStartStop];
        }else if ((int)time % 60 == 0) {
            [self deleteAnimationLayer];
            [self createAnimationLayer];
        }
    }
}

- (BOOL)isCreateStart{
    double timeGap = [TimeData getTimeGap:startDate];
    if([[TimeData getLastHourData] count] > 0 && timeGap < 10){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"lessThan10s", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"know", nil)otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    return true;
}

- (BOOL)isCreateStop{
    double timeGap = [stopDate timeIntervalSinceDate:startDate];
    if(timeGap < 5){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"lessThan5s", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"know", nil)otherButtonTitles:nil, nil];
        [alert show];
    return false;
    }
    return true;
}

- (void)createRecordData{
    double timeGap = [TimeData getTimeGap:startDate];
    timeGap = timeGap > 60*60 ? 0 : timeGap;    
    double timeLength = [stopDate timeIntervalSinceDate:startDate];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentYearMonth = [dateFormatter stringFromDate:startDate];
    [dic setValue:currentYearMonth forKey:@"yearMonth"];
    [dic setObject:startDate forKey:@"startTime"];
    [dic setObject:stopDate forKey:@"stopTime"];
    [dic setValue:[NSNumber numberWithInt:timeLength] forKey:@"timeLength"];
    [dic setValue:[NSNumber numberWithInt:timeGap] forKey:@"timeGap"];
    
    [TimeData insertData:dic];
    [self setCountTimes];
}

- (void)setCountTimes{
    [list reloadTableViewData];
    countTitle.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[TimeData getLastHourData] count]];
    [continueTimer reset];
    [gapTimer reset];
    [continueTimer setStopWatchTime:[TimeData getLastHourPersisCount]];
    [gapTimer setStopWatchTime:[TimeData getLastHourGapCount]];
}

- (void)createDisplayLabel{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    float width = rect.size.width/3;
    
    UILabel *averageTitle = [[UILabel alloc] initWithFrame:CGRectMake(3, rect.size.height/2 + 50, 150, 20)];
    [averageTitle setTextColor:[UIColor orangeColor]];
    [averageTitle setFont:[UIFont systemFontOfSize:16.0f]];
    [averageTitle setText:NSLocalizedString(@"averageTitle", nil)];
    [self.view addSubview:averageTitle];
    
    UILabel *persistTitle = [[UILabel alloc] initWithFrame:CGRectMake(width, rect.size.height/2 + 80, width, 20)];
    [persistTitle setTextColor:[UIColor orangeColor]];
    [persistTitle setFont:[UIFont systemFontOfSize:16.0f]];
    persistTitle.textAlignment = NSTextAlignmentCenter;
    [persistTitle setText:NSLocalizedString(@"averageDuration", nil)];
    [self.view addSubview:persistTitle];
    
    UILabel *gapTitle = [[UILabel alloc] initWithFrame:CGRectMake(width*2, rect.size.height/2 + 80, width, 20)];
    [gapTitle setTextColor:[UIColor orangeColor]];
    gapTitle.textAlignment = NSTextAlignmentCenter;
    [gapTitle setFont:[UIFont systemFontOfSize:16.0f]];
    [gapTitle setText:NSLocalizedString(@"averageFrequency", nil)];
    [self.view addSubview:gapTitle];

    countTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.size.height/2 + 80, width, 45)];
    countTitle.textAlignment = NSTextAlignmentCenter;
    [countTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:45.0]];
    [countTitle setText:@"0"];
    [countTitle setTextColor:[UIColor orangeColor]];
    [self.view addSubview:countTitle];
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/4 - 50, rect.size.height/2 + 110, 50, 30)];
    count.textAlignment = NSTextAlignmentRight;
    [count setFont:[UIFont systemFontOfSize:13.0]];
    [count setTextColor:[UIColor grayColor]];
    [count setText:NSLocalizedString(@"time", nil)];
    [self.view addSubview:count];
}

- (void)createCycleBackground{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    [path addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/4 + 35) radius:150 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *arcLayer = [CAShapeLayer layer];
    arcLayer.path = path.CGPath;
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.strokeColor = [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor;
    arcLayer.lineWidth = 1;
    arcLayer.lineCap = kCALineCapRound;
    arcLayer.frame = self.view.frame;
    arcLayer.shadowColor = [UIColor grayColor].CGColor;
    arcLayer.shadowOpacity = 0.8;
    arcLayer.shadowOffset = CGSizeMake(0.0, 0.0);
    [self.view.layer addSublayer:arcLayer];
    
    UIBezierPath *_path = [UIBezierPath bezierPath];
    [_path addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/4 + 35) radius:130 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *_arcLayer = [CAShapeLayer layer];
    _arcLayer.path = _path.CGPath;
    _arcLayer.fillColor = [UIColor clearColor].CGColor;
    _arcLayer.strokeColor = [UIColor greenColor].CGColor;
    _arcLayer.lineWidth = 4;
    _arcLayer.lineCap = kCALineCapRound;
    _arcLayer.frame = self.view.frame;
    _arcLayer.shadowColor = [UIColor grayColor].CGColor;
    _arcLayer.shadowOpacity = 0.8;
    _arcLayer.shadowOffset = CGSizeMake(0.0, 0.0);
    [self.view.layer addSublayer:_arcLayer];
}

- (void)createAnimationLayer
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    [path addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/4 + 35) radius:130 startAngle:-M_PI_2 endAngle:1.5*M_PI clockwise:YES];
    rotateLayer = [CAShapeLayer layer];
    rotateLayer.path = path.CGPath;
    rotateLayer.fillColor = [UIColor clearColor].CGColor;
    rotateLayer.strokeColor = [UIColor orangeColor].CGColor;
    rotateLayer.lineWidth = 4;
    rotateLayer.lineCap = kCALineCapRound;
    rotateLayer.frame = self.view.frame;
    [self.view.layer addSublayer:rotateLayer];
    [self drawLineAnimation:rotateLayer];
}

- (void)drawLineAnimation:(CAShapeLayer*)layer
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 60;
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

- (void)deleteAnimationLayer{
    [rotateLayer removeAllAnimations];
    [rotateLayer removeFromSuperlayer];
}

- (void)detailInfo{
    DetailViewController *detail = [[DetailViewController alloc] init];
    UINavigationController *navControll = [[UINavigationController alloc] initWithRootViewController:detail];
    [self.view.window.rootViewController presentViewController:navControll animated:YES completion:nil];
}

- (void)historyInfo{
    HistoryViewController *history = [[HistoryViewController alloc] init];
    history.root = self;
    UINavigationController *navControll = [[UINavigationController alloc] initWithRootViewController:history];
    [self.view.window.rootViewController presentViewController:navControll animated:YES completion:nil];
}

- (void)telphoneInfo{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"numberDesc", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"btnCancel", nil) destructiveButtonTitle:NSLocalizedString(@"dailNumber", nil) otherButtonTitles:NSLocalizedString(@"setNumber", nil), nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"numberLabel", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"btnCancel", nil) otherButtonTitles:NSLocalizedString(@"btnConfirm", nil), nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView textFieldAtIndex:0].text = [TimeData getDialNumber];
        [alertView show];
    }else if(buttonIndex == 0){
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [TimeData getDialNumber]]];
        if (!phoneCallWebView) {
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *field = [alertView textFieldAtIndex:0];
    if(![field.text isEqualToString:@""]){
        if(buttonIndex == 1){
            [TimeData setDialNumber:field.text];
        }
    }
}

@end
