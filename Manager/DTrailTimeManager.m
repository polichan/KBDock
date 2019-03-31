//
//  DTrailTimeManager.m
//  DObject
//
//  Created by 陈鹏宇 on 2019/3/11.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import "DTrailTimeManager.h"
#import "../KBDockMacro.h"

@implementation DTrailTimeManager
+ (BOOL)compareWithCreatedTime:(NSString *)createdTime futureTime:(NSString *)futureTime currentTime:(NSString *)currentTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:MM:ss"];//@"yyyy-MM-dd-HHMMss"

    //NSDate* date = [NSDate dateWithTimeIntervalSince1970:[createdTime doubleValue]];

    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[currentTime doubleValue]];
    // NSString *dateString2 = [formatter stringFromDate:date2];
    // ACLog(@"当前时间: %@", dateString2);

    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:[futureTime doubleValue]];
    // NSString *dateString3 = [formatter stringFromDate:date3];
    // ACLog(@"结束时间: %@", dateString3);

    NSTimeInterval seconds = [date3 timeIntervalSinceDate:date2];
    if (seconds > 0) {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)compareWithFutureTime:(NSString *)futureTime currentTime:(NSString *)currentTime{
    return [DTrailTimeManager compareWithCreatedTime:nil futureTime:futureTime currentTime:currentTime];
}

@end
