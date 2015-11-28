//
//  TimeData.m
//  GongSuo
//
//  Created by 邓鹏 on 14/9/26.
//  Copyright (c) 2014年 com.kevin. All rights reserved.
//

#import "TimeData.h"

#define DateStore [NSUserDefaults standardUserDefaults]

@implementation TimeData

+ (void)initData{
    NSUserDefaults *userDefaults = DateStore;
    if(![userDefaults stringForKey:@"dialNumber"]){
        [userDefaults setValue:@"120" forKey:@"dialNumber"];
    }
    
    if(![userDefaults valueForKey:@"timeArray"]){
        [userDefaults setValue:[[NSMutableArray alloc] init] forKey:@"timeArray"];
    }
    [userDefaults synchronize];
}

+ (NSMutableArray *)getData{
    NSUserDefaults *userDefaults = DateStore;
    return (NSMutableArray *)[userDefaults valueForKey:@"timeArray"];
}

+ (NSMutableArray *)getDataForSection{
    NSUserDefaults *userDefaults = DateStore;
    return (NSMutableArray *)[userDefaults valueForKey:@"timeArray"];
}

+ (void)insertData:(NSMutableDictionary *)object{
    NSUserDefaults *userDefaults = DateStore;
    NSMutableArray *array = [NSMutableArray arrayWithArray:[userDefaults valueForKey:@"timeArray"]];
    [array insertObject:object atIndex:0];
    [userDefaults setValue:[NSMutableArray arrayWithArray:array] forKey:@"timeArray"];
    [userDefaults synchronize];
}

+ (void)deleteData:(NSUInteger)index{
    NSUserDefaults *userDefaults = DateStore;
    NSMutableArray *array = [NSMutableArray arrayWithArray:[userDefaults valueForKey:@"timeArray"]];
    [array removeObjectAtIndex:index];
    [userDefaults setValue:[NSMutableArray arrayWithArray:array] forKey:@"timeArray"];
    [userDefaults synchronize];
}

+ (void)deleteAllData{
    NSUserDefaults *userDefaults = DateStore;
    NSMutableArray *array = [NSMutableArray arrayWithArray:[userDefaults valueForKey:@"timeArray"]];
    [array removeAllObjects];
    [userDefaults setValue:[[NSMutableArray alloc] init] forKey:@"timeArray"];
    [userDefaults synchronize];
}

+ (NSString *)getDialNumber{
    NSUserDefaults *userDefaults = DateStore;
    return [userDefaults valueForKey:@"dialNumber"];
}

+ (void)setDialNumber:(NSString *)number{
    NSUserDefaults *userDefaults = DateStore;
    [userDefaults setValue:number forKey:@"dialNumber"];
    [userDefaults synchronize];
}

+ (NSMutableArray *)getLastHourData{
    NSUserDefaults *userDefaults = DateStore;
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    NSMutableArray *oldArray = (NSMutableArray *)[userDefaults valueForKey:@"timeArray"];
    if([oldArray count] > 0){
        NSDate *baseDate = [[oldArray objectAtIndex:0] objectForKey:@"startTime"];
        for (int i = 0; i < [oldArray count]; i++) {
            NSDictionary *dic = [oldArray objectAtIndex:i];
            double timeLength = [baseDate timeIntervalSinceDate:[dic objectForKey:@"startTime"]];
            double timeGap = [[dic objectForKey:@"timeGap"] doubleValue];
            if (i == 0 || (timeLength <= 60*60 && timeGap < 60*60)) {
                [newArray insertObject:[NSMutableDictionary dictionaryWithDictionary:dic] atIndex:0];
            }
        }
    }
    [newArray sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        return true;
    }];
    return newArray;
}

+ (double)getLastHourPersisCount{
    double count = 0.0f;
    NSMutableArray *arr = [self getLastHourData];
    for (int i = 0; i < [arr count]; i++) {
        count = count + [[[arr objectAtIndex:i] objectForKey:@"timeLength"] doubleValue];
    }
    if ([arr count] > 0) {
        count = count/[arr count];
    }
    return count;
}

+ (double)getLastHourGapCount{
    double count = 0.0f;
    NSMutableArray *arr = [self getLastHourData];
    for (int i = 0; i < [arr count]; i++) {
        count = count + [[[arr objectAtIndex:i] objectForKey:@"timeGap"] doubleValue];
    }
    if ([arr count] > 0) {
        count = count/[arr count];
    }
    return count;
}

+ (double)getTimeGap:(NSDate *)date{
    NSUserDefaults *userDefaults = DateStore;
    NSMutableArray *array = [NSMutableArray arrayWithArray:[userDefaults valueForKey:@"timeArray"]];

    if([array count] > 0){
        return [date timeIntervalSinceDate:[[array objectAtIndex:0] objectForKey:@"stopTime"]];
    }else{
        return 0.0f;
    }
}

@end
