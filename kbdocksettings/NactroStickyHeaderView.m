//
//  NactroStickyHeaderView.m
//  StickyHeader
//
//  Created by 开发者  on 2019/3/29.
//  Copyright © 2019年 开发者 . All rights reserved.
//

#import "NactroStickyHeaderView.h"
#import "UIFont+Extension.h"

@interface NactroStickyHeaderView()
@property (nonatomic, strong) UILabel *devNameLabel;
@property (nonatomic, strong) UILabel *tweakNameLabel;
@end

@implementation NactroStickyHeaderView

- (instancetype)initWithDevName:(NSString *)devName tweakName:(NSString *)tweakName tweakVersion:(NSString *)tweakVersion backgroundColor:(UIColor *)backgroundColor{
    self = [super init];
    if (self) {
        [self createUIWithDevName:devName tweakName:tweakName tweakVersion:tweakVersion backgroundColor:backgroundColor];
    }
    return self;
}

- (void)createUIWithDevName:(NSString *)devName tweakName:(NSString *)tweakName tweakVersion:(NSString *)tweakVersion backgroundColor:(UIColor *)backgroundColor{
    self.backgroundColor = backgroundColor;
    // 添加到视图上
    [self addSubview:self.tweakNameLabel];
    [self addSubview:self.devNameLabel];

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",tweakName,tweakVersion]];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont PingFangMediumForSize:31] range:NSMakeRange(0, 4)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont PingFangMediumForSize:22] range:NSMakeRange(4, 7)];

    self.devNameLabel.text = devName;
    self.tweakNameLabel.attributedText = attributedStr;

    //Stack View
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentLeading;
    stackView.spacing = 5;

    [stackView addArrangedSubview:self.devNameLabel];
    [stackView addArrangedSubview:self.tweakNameLabel];

    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:stackView];

    //Layout for Stack View
    [[stackView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:15]setActive:YES];
    [[stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-30]setActive:YES];
}

#pragma mark - 懒加载
- (UILabel *)devNameLabel{
    if (!_devNameLabel) {
        _devNameLabel = [[UILabel alloc]init];
        _devNameLabel.textColor = [UIColor whiteColor];
        _devNameLabel.font = [UIFont PingFangSemiboldForSize:22];
    }
    return _devNameLabel;
}

- (UILabel *)tweakNameLabel{
    if (!_tweakNameLabel) {
        _tweakNameLabel = [[UILabel alloc]init];
        _tweakNameLabel.textColor = [UIColor whiteColor];
    }
    return _tweakNameLabel;
}

@end
