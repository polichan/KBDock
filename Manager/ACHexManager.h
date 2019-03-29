//
//  ACHexManager.h
//  achelper
//
//  Created by 陈鹏宇 on 2019/3/14.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACHexManager : NSObject
+ (NSString *)stringFromHexString:(NSString *)hexString;
+ (NSString *)hexStringFromString:(NSString *)string;
@end
