//
//  DLicenseManager.h
//  achelper
//
//  Created by 陈鹏宇 on 2019/3/10.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLicenseManager : NSObject

/**
 验证签名类方法

 @param licenseFilePath license文件位置
 @param publicKey 公钥字符串
 @return 是否有效
 */
+ (BOOL)verifyLicenseFromPath:(NSString *)licenseFilePath publicKey:(NSString *)publicKey bundleName:(NSString *)bundleName  udid:(NSString *)udid;

/**
 验证试用证书签名方法

 @param trailerLicensePath 试用证书文件路径
 @param publicKey 公钥文件
 @return 返回是否有效
 */
+ (BOOL)verifyTrailerLicenseFromPath:(NSString *)trailerLicensePath publicKey:(NSString *)publicKey bundleName:(NSString *)bundleName udid:(NSString *)udid;
/**
 写入签名文件

 @param licenseString license字符串，注意是拼接后的
 @param licensePath 写入的文件地址
 */
+ (void)writeLicenseToDiskWithLicenseString:(NSString *)licenseString atPath:(NSString *)licensePath;

@end
