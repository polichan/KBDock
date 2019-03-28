//
//  UIImpactFeedbackGenerator+Feedback.m
//  slsc
//
//  Created by 陈鹏宇 on 2019/2/16.
//  Copyright © 2019年 ChenPengyu. All rights reserved.
//

#import "UIImpactFeedbackGenerator+Feedback.h"

@implementation UIImpactFeedbackGenerator (Feedback)

+ (void)generateFeedbackWithStyle:(UIImpactFeedbackStyle)feedbackStyle{
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:feedbackStyle];
        [generator prepare];
        [generator impactOccurred];
}

+ (void)generateFeedbackWithLightStyle{
        return [UIImpactFeedbackGenerator generateFeedbackWithStyle:UIImpactFeedbackStyleLight];
}
+ (void)generateFeedbackWithMediumStyle{
        return [UIImpactFeedbackGenerator generateFeedbackWithStyle:UIImpactFeedbackStyleMedium];
}
+ (void)generateFeedbackWithHeavyStyle{
        return [UIImpactFeedbackGenerator generateFeedbackWithStyle:UIImpactFeedbackStyleHeavy];
}
@end
