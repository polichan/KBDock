//
//  KBAppManager.h
//  KBDOCK
//
//  Created by 开发者  on 2019/3/28.
//  Copyright © 2019年 开发者 . All rights reserved.
//

#import <Foundation/Foundation.h>
@interface KBAppManager : NSObject
+ (NSMutableArray *)getAppListToArrayWithAppPlistPath:(NSString *)appPlistPath;
@end
