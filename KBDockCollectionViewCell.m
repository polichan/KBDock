//
//  KBDockCollectionViewCell.m
//  KBDock
//
//  Created by 陈鹏宇  on 2019/3/26.
//  Copyright © 2019年 陈鹏宇 . All rights reserved.
//

#import "KBDockCollectionViewCell.h"
#import "Common.h"

@interface KBDockCollectionViewCell()
@property (nonatomic, strong) UIButton *clickBtn;
@end

@implementation KBDockCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
  self.appImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,30,30)];
  self.appImageView.layer.cornerRadius = 3;
  self.appImageView.clipsToBounds = YES;
  [self.contentView addSubview:self.appImageView];
}
@end
