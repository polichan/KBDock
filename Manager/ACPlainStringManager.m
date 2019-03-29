//
//  ACPlainStringManager.m
//  achelper
//
//  Created by 陈鹏宇 on 2019/3/9.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import "ACPlainStringManager.h"
#import "NSString+URL.h"
#import "../KBDockMacro.h"

@implementation ACPlainStringManager
+ (NSString *)payTweakWithPlainStringAppendingByCode:(NSString *)code orderNumber:(NSString *)orderNumber scheme:(NSString *)scheme status:(NSString *)status url:(NSString *)url{
    NSString *encodedScheme = [scheme URLEncodedString];
    NSString *encodedURL = [url URLEncodedString];
    NSString *appendingString = [NSString stringWithFormat:@"code=%@&order_no=%@&scheme=%@&status=%@&url=%@",code,orderNumber,encodedScheme,status,encodedURL];
    return appendingString;
}
+ (NSString *)getActivationCodeWithPlainStringAppeddingByActivateCode:(NSString *)activateCode code:(NSString *)code status:(NSString *)status{
    NSString *appendingString = [NSString stringWithFormat:@"activate_code=%@&code=%@&status=%@",activateCode,code,status];
    return appendingString;
}

+ (NSString *)activateTweakWithPlainStringAppeningByCode:(NSString *)code license:(NSString *)license message:(NSString *)message status:(NSString *)status time:(NSString *)time{
    NSString *encodedLicense = [license URLEncodedString];
    NSString *appendingString = [NSString stringWithFormat:@"code=%@&license=%@&message=%@&status=%@&time=%@",code,encodedLicense,message,status,time];
    return appendingString;
}

+ (NSString *)activateTweakWithPlainStringAppeningByActivationCode:(NSString *)activationCode udid:(NSString *)udid time:(NSString *)time{
    NSString *appendingString = [NSString stringWithFormat:@"%@%@%@",activationCode,udid,time];
    return appendingString;
}

+ (NSString *)trailerWithPlainStringAppendingByCode:(NSString *)code createdTime:(NSString *)createdTime futureTime:(NSString *)futureTime license:(NSString *)license message:(NSString *)message status:(NSString *)status time:(NSString *)time{
    NSString *encodedLicense = [license URLEncodedString];
    NSString *appendingString = [NSString stringWithFormat:@"code=%@&created_time=%@&future_time=%@&license=%@&message=%@&status=%@&time=%@",code,createdTime,futureTime,encodedLicense,message,status,time];
    ACLog(@"trailerLicenseByCode--->%@",appendingString);
    return appendingString;
}

+ (NSString *)trailerLicenseWithPlainStringAppendingByPackage:(NSString *)package udid:(NSString *)udid createdTime:(NSString *)createdTime futureTime:(NSString *)futureTime{
    NSString *appendingString = [NSString stringWithFormat:@"%@%@%@%@",package,udid,createdTime,futureTime];
    ACLog(@"trailerLicense--->%@",appendingString);
    return appendingString;
}

+ (NSString *)trailerLicenseWithPlainStringAppendingByTagWtihPackage:(NSString *)package udid:(NSString *)udid createdTime:(NSString *)createdTime futureTime:(NSString *)futureTime{
    NSString *currentTag = @"current";
    NSString *futureTag = @"future";
    NSString *appendingString = [NSString stringWithFormat:@"%@%@%@%@%@%@",package,udid,currentTag,createdTime,futureTag,futureTime];
    ACLog(@"trailerLicenseWithTag--->%@",appendingString);
    return appendingString;
}

+ (NSString *)licenseAppendingByLicense:(NSString *)license plainString:(NSString *)plainString{
    NSString *appendingString = [NSString stringWithFormat:@"%@nactro%@",license,plainString];
    return appendingString;
}

+ (NSString *)trialLicenseAppendingByLicense:(NSString *)license plainString:(NSString *)plainString{
    NSString *appendingString = [NSString stringWithFormat:@"%@trial%@",license,plainString];
    return appendingString;
}
@end
