//
//  ACUDIDManager.h
//  achelper
//
//  Created by 开发者  on 2019/3/31.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACUDIDManager : NSObject
+ (void)writeUDIDToPath:(NSString *)path;
+ (BOOL)checkUDIDFileIfExistOnPath:(NSString *)path;
+ (NSString *)getUDIDFromPath:(NSString *)path;
@end

