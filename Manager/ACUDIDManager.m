//
//  ACUDIDManager.m
//  achelper
//
//  Created by 开发者  on 2019/3/31.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import "ACUDIDManager.h"
#import "ACHexManager.h"
#import "../KBDockMacro.h"
#import "UIDevice+MobileGestaltCategory.h"

@implementation ACUDIDManager

+ (void)writeUDIDToPath:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL pathNULL = kStringIsEmpty(path);
    if (!pathNULL) {
        BOOL ifFileExist = [ACUDIDManager checkUDIDFileIfExistOnPath:path];
        if (ifFileExist) {
            ACLog(@"udid文件已经存在，正在准备删除");
            [manager removeItemAtPath:path error:nil];
            ACLog(@"udid文件已经删除");
            ACLog(@"重新写入");
            NSString *udid = [[UIDevice currentDevice]UDID];
            NSString *hexUDIDString = [ACHexManager hexStringFromString:udid];
            NSData *udidData = [hexUDIDString dataUsingEncoding:NSUTF8StringEncoding];
            [udidData writeToFile:path atomically:YES];
        }else{
            NSString *udid = [[UIDevice currentDevice]UDID];
            [ACHexManager hexStringFromString:udid];
            NSData *udidData = [udid dataUsingEncoding:NSUTF8StringEncoding];
            [udidData writeToFile:path atomically:YES];
        }
    }else{
        ACLog(@"请传入路径");
    }
}

+ (BOOL)checkUDIDFileIfExistOnPath:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL pathNUll = kStringIsEmpty(path);
    if (!pathNUll) {
        if ([manager fileExistsAtPath:path]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
+ (NSString *)getUDIDFromPath:(NSString *)path{
    BOOL pathNULL = kStringIsEmpty(path);
    if (!pathNULL) {
        BOOL ifFileExist = [ACUDIDManager checkUDIDFileIfExistOnPath:path];
        if (ifFileExist) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSString *udidWith16System = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *convertToString = [ACHexManager stringFromHexString:udidWith16System];
            return convertToString;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

@end
