//
//  KBApplicationModel.m
//  achelper
//
//  Created by 开发者  on 2019/3/28.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import "KBApplicationModel.h"

@implementation KBApplicationModel
- (instancetype)initWithDisplayIdentifier:(NSString *)displayIdentifier iconPath:(NSString *)iconPath{
    self = [super init];
    if (self) {
        self.displayIdentifier = displayIdentifier;
        self.iconPath = iconPath;
    }
    return self;
}
@end
