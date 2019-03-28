//
//  KBAppManager.m
//  KBDOCK
//
//  Created by 开发者  on 2019/3/28.
//  Copyright © 2019年 开发者 . All rights reserved.
//

#import "KBAppManager.h"

@implementation KBAppManager
+ (NSMutableArray *)getAppListToArrayWithAppPlistPath:(NSString *)plistPath{
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
