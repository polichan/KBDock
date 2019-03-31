//
//  ACUDIDGetter.m
//  achelper
//
//  Created by 开发者  on 2019/3/31.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import "ACUDIDGetter.h"
#import "ACHexManager.h"
#import "../KBDockMacro.h"

@implementation ACUDIDGetter

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
        BOOL ifFileExist = [ACUDIDGetter checkUDIDFileIfExistOnPath:path];
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
