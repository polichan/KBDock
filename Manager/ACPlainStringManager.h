//
//  ACPlainStringManager.h
//  achelper
//
//  Created by 陈鹏宇 on 2019/3/9.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ACPlainStringManager : NSObject
+ (NSString *)payTweakWithPlainStringAppendingByCode:(NSString *)code orderNumber:(NSString *)orderNumber scheme:(NSString *)scheme status:(NSString *)status url:(NSString *)url;
+ (NSString *)getActivationCodeWithPlainStringAppeddingByActivateCode:(NSString *)activateCode code:(NSString *)code status:(NSString *)status;
+ (NSString *)activateTweakWithPlainStringAppeningByCode:(NSString *)code license:(NSString *)license message:(NSString *)message status:(NSString *)status time:(NSString *)time;
+ (NSString *)activateTweakWithPlainStringAppeningByActivationCode:(NSString *)activationCode udid:(NSString *)udid time:(NSString *)time;


+ (NSString *)trailerWithPlainStringAppendingByCode:(NSString *)code createdTime:(NSString *)createdTime futureTime:(NSString *)futureTime license:(NSString *)license message:(NSString *)message status:(NSString *)status time:(NSString *)time;
+ (NSString *)trailerLicenseWithPlainStringAppendingByPackage:(NSString *)package udid:(NSString *)udid createdTime:(NSString *)createdTime futureTime:(NSString *)futureTime;

/**
 拼接 license 与 plainString

 @param plainString 原始文本
 @param license 服务器返回的 license
 @return return 返回拼接后的字符串
 */
+ (NSString *)licenseAppendingByLicense:(NSString *)license plainString:(NSString *)plainString;

/**
 拼接 试用证书文件 与 plainString

 @param license license 服务器返回
 @param plainString 原始签名的文本
 @return 返回拼接后的字符串，用于写入
 */
+ (NSString *)trialLicenseAppendingByLicense:(NSString *)license plainString:(NSString *)plainString;

/**
 拼接 试用证书文件 与 plainString Tag 拼接,用于写入

 @param package 包名
 @param udid udid
 @param createdTime 创建时间
 @param futureTime 未来时间
 @return 返回拼接后的
 */
+ (NSString *)trailerLicenseWithPlainStringAppendingByTagWtihPackage:(NSString *)package udid:(NSString *)udid createdTime:(NSString *)createdTime futureTime:(NSString *)futureTime;
@end
