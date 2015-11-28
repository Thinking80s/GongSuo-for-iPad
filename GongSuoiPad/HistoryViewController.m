//
//  HistoryViewController.m
//  GongSuo
//
//  Created by 邓鹏 on 14/10/11.
//  Copyright (c) 2014年 com.kevin. All rights reserved.
//

#import "HistoryViewController.h"
#import "TimeTableViewCell.h"
#import "TimeData.h"

@interface HistoryViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *table;
}
@end

@implementation HistoryViewController

@synthesize root;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"history", nil)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                target:self action:@selector(close)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self createRightButton];
    table = [[UITableView alloc] init];
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    [table setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height + 20)];
    table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (void)createRightButton{
    if([[TimeData getData] count] > 0){
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                     target:self action:@selector(deleteAll)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)deleteAll
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"recordAllDeleteConfirm", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"btnCancel", nil) destructiveButtonTitle:NSLocalizedString(@"recordAllDelete", nil) otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [TimeData deleteAllData];
        [table reloadData];
        [self createRightButton];
    }
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.root setCountTimes];        
    }];
}

- (UIColor *)getStatusColor:(int)val{
    UIColor *color = [UIColor greenColor];
    if (val == 0) {
        color = [UIColor greenColor];
    }else if (val < 6*60) {
        color = [UIColor yellowColor];
    }else if(val < 11*60){
        color = [UIColor redColor];
    }
    return color;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[TimeData getData] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * showUserInfoCellIdentifier = @"Cell";
    TimeTableViewCell *cell = [table dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil){
        cell = [[TimeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                        reuseIdentifier:showUserInfoCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableArray *arr = [TimeData getData];
    NSDictionary *dic = [arr objectAtIndex:[indexPath row]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    cell.startVal.text = [dateFormatter stringFromDate:[dic objectForKey:@"startTime"]];
    cell.endVal.text = [dateFormatter stringFromDate:[dic objectForKey:@"stopTime"]];
    [cell.persisValTimer setStopWatchTime:[[dic objectForKey:@"timeLength"] intValue]];
    [cell.gapValTimer setStopWatchTime:[[dic objectForKey:@"timeGap"] intValue]];
    cell.gapVal.textColor = [self getStatusColor:[[dic objectForKey:@"timeGap"] intValue]];    
    
    cell.startLabel.text = NSLocalizedString(@"startTime", nil);
    cell.endLabel.text = NSLocalizedString(@"endTime", nil);
    cell.persisLabel.text = NSLocalizedString(@"duration", nil);
    cell.gapLabel.text = NSLocalizedString(@"frequency", nil);
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    [TimeData deleteData: row];
    [table reloadData];
    [self createRightButton];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
