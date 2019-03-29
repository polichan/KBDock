//
//  DTrailTimeManager.h
//  DObject
//
//  Created by 陈鹏宇 on 2019/3/11.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTrailTimeManager : NSObject
+ (BOOL)compareWithCreatedTime:(NSString *)createdTime futureTime:(NSString *)futureTime currentTime:(NSString *)currentTime;
+ (BOOL)compareWithFutureTime:(NSString *)futureTime currentTime:(NSString *)currentTime;
@end
