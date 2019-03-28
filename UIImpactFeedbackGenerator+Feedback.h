//
//  UIImpactFeedbackGenerator+Feedback.h
//  slsc
//
//  Created by 陈鹏宇 on 2019/2/16.
//  Copyright © 2019年 ChenPengyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImpactFeedbackGenerator (Feedback)
+ (void)generateFeedbackWithStyle:(UIImpactFeedbackStyle)feedbackStyle;
+ (void)generateFeedbackWithLightStyle;
+ (void)generateFeedbackWithMediumStyle;
+ (void)generateFeedbackWithHeavyStyle;
@end

NS_ASSUME_NONNULL_END
