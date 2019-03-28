//
//  KBApplicationModel.h
//  achelper
//
//  Created by 开发者  on 2019/3/28.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBApplicationModel : NSObject
@property (nonatomic, copy) NSString *displayIdentifier;
@property (nonatomic, copy) NSString *iconPath;
- (instancetype)initWithDisplayIdentifier:(NSString *)displayIdentifier iconPath:(NSString *)iconPath;
@end
