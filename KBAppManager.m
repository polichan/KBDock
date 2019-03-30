//
//  KBAppManager.m
//  KBDOCK
//
//  Created by 开发者  on 2019/3/28.
//  Copyright © 2019年 开发者 . All rights reserved.
//

#import "KBAppManager.h"

static KBAppManager *_sharedManager = nil;

@implementation KBAppManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sharedManager == nil) {
            _sharedManager = [[self alloc]init];
        }
    });
    return _sharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [super allocWithZone:zone];
    });
    return _sharedManager;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _sharedManager;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _sharedManager;
}

- (NSMutableArray *)getAppListToArrayWithAppPlistPath:(NSString *)plistPath{
    NSDictionary *appListDict= [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:100];
    for (NSString *displayIdentifier in appListDict) {
        BOOL canOpenApp = [[appListDict objectForKey:displayIdentifier]boolValue];
        if (canOpenApp) {
            [array addObject:displayIdentifier];
        }
    }
    return array;
}

@end
