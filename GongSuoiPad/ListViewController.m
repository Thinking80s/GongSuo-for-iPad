//
//  ListViewController.m
//  GongSuo
//
//  Created by 邓鹏 on 14/9/7.
//  Copyright (c) 2014年 com.kevin. All rights reserved.
//

#import "ListViewController.h"
#import "TimeTableViewCell.h"
#import "TimeData.h"

@interface ListViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
}
@end

@implementation ListViewController

@synthesize root;

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
    table = [[UITableView alloc] init];
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    [table setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - (rect.size.height/2 + 120))];
    table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (void)reloadTableViewData{
    [table reloadData];
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
    return [[TimeData getLastHourData] count];
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
    
    NSMutableArray *arr = [TimeData getLastHourData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[TimeData getLastHourData] count] > 0 ? 1 : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [[[TimeData getLastHourData] objectAtIndex:0] objectForKey:@"yearMonth"];
    return [NSString stringWithFormat:@" %@", title];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
