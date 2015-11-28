//
//  TimeData.h
//  GongSuo
//
//  Created by 邓鹏 on 14/9/26.
//  Copyright (c) 2014年 com.kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeData : NSObject

+ (void)initData;

+ (NSMutableArray *)getData;

+ (NSMutableArray *)getDataForSection;

+ (void)insertData:(NSMutableDictionary *)object;

+ (void)deleteData:(NSUInteger)index;

+ (void)deleteAllData;

+ (NSString *)getDialNumber;

+ (void)setDialNumber:(NSString *)number;

+ (NSMutableArray *)getLastHourData;

+ (double)getTimeGap:(NSDate *)date;

+ (double)getLastHourPersisCount;

+ (double)getLastHourGapCount;

@end
