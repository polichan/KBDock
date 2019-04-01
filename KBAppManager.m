//
//  KBAppManager.m
//  KBDOCK
//
//  Created by 开发者  on 2019/3/28.
//  Copyright © 2019年 开发者 . All rights reserved.
//

#import "KBAppManager.h"
#import <AppList/AppList.h>

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
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *displayIdentifier in appListDict) {
        BOOL canOpenApp = [[appListDict objectForKey:displayIdentifier]boolValue];
        if (canOpenApp) {
            [array addObject:displayIdentifier];
        }
    }
    return array;
}

- (NSMutableArray *)getSortedAppListArrayFromPath:(NSString *)path{
    NSMutableArray *array = [NSMutableArray array];
    array  = [NSArray arrayWithContentsOfFile:path];
    return array;
}

- (UIImage *)getImageWithDisplayIdentifier:(NSString *)displayIdentifier{
  UIImage *image = [[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:displayIdentifier];
  return image;
}

- (void)updateAppListWithNewArray:(NSMutableArray *)array toPath:(NSString *)path{
    [array writeToFile:path atomically:YES];
}

@end
