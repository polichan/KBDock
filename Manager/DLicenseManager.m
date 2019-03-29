//
//  DLicenseManager.m
//  achelper
//
//  Created by 陈鹏宇 on 2019/3/10.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import "DLicenseManager.h"
#import "DRSACryption.h"
#import "ACPlainStringManager.h"
#import "ACHexManager.h"
#import "DTrailTimeManager.h"
#import "../KBDockMacro.h"

@implementation DLicenseManager

+ (BOOL)verifyLicenseFileWithPath:(NSString *)licenseFilePath plainStringFilePath:(NSString *)plainStringFilePath publicKey:(NSString *)publicKey{
    // 判断是否存在 dat 文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 如果存在两个文件都存在，则进行下一步
    if ([fileManager fileExistsAtPath:licenseFilePath] && [fileManager fileExistsAtPath:plainStringFilePath]) {
        // 首先从路径中读取 dat 文件
        NSData *signatureData = [NSData dataWithContentsOfFile:licenseFilePath];
        NSData *plainData = [NSData dataWithContentsOfFile:plainStringFilePath];
        // dat 文件转换成 NSString
        NSString *signature  =[[NSString alloc]initWithData:signatureData encoding:NSUTF8StringEncoding];
        NSString *verifyString = [[NSString alloc]initWithData:plainData encoding:NSUTF8StringEncoding];
        // 加载验签类
        DRSACryption *rsaCryption = [[DRSACryption alloc]init];
        SecKeyRef pubkey = [DRSACryption publicKeyFromString:publicKey keySize:2048];
        rsaCryption.publicKey = pubkey;
        // 利用 BOOL 接收返回值
        BOOL result = [rsaCryption rsaSHA256VertifyingString:verifyString withSignature:signature];
        if (result) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

+ (BOOL)verifyLicenseFromPath:(NSString *)licenseFilePath publicKey:(NSString *)publicKey{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:licenseFilePath]) {
        NSData *data = [NSData dataWithContentsOfFile:licenseFilePath];
        NSString *wrappedLicense = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        // Hex 转 String
        NSString *convertToString = [ACHexManager stringFromHexString:wrappedLicense];
        // 解析 String 去除 连接符
        NSArray *array = [convertToString componentsSeparatedByString:@"nactro"];
        DRSACryption *rsaCryption = [[DRSACryption alloc]init];
        SecKeyRef pubKey = [DRSACryption publicKeyFromString:publicKey keySize:2048];
        rsaCryption.publicKey = pubKey;
        BOOL result = [rsaCryption rsaSHA256VertifyingString:[array lastObject] withSignature:[array firstObject]];
        if (result) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

+ (BOOL)verifyTrailerLicenseFromPath:(NSString *)trailerLicensePath publicKey:(NSString *)publicKey{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL resultNull = kStringIsEmpty(trailerLicensePath);
    if (resultNull) {
        ACLog(@"请传入试用文件路径");
        return NO;
    }else{
        // 是否存在此文件
        if ([fileManager fileExistsAtPath:trailerLicensePath]) {
            // 如果存在，开始验证
            NSData *data = [NSData dataWithContentsOfFile:trailerLicensePath];
            NSString *wrappedLicense = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            // Hex 转 String
            NSString *convertToString = [ACHexManager stringFromHexString:wrappedLicense];
            // 解析 String 去除 连接符 trial
            NSArray *array = [convertToString componentsSeparatedByString:@"trial"];
            // 把 future 字符串去掉
            NSString *lastObjectArrayString = [array lastObject];
            NSString *noFutureTime = [lastObjectArrayString stringByReplacingOccurrencesOfString:@"future" withString:@""];
            NSString *noCurrentTime = [noFutureTime stringByReplacingOccurrencesOfString:@"current" withString:@""];
            NSString *plainString = noCurrentTime;
            DRSACryption *rsaCryption = [[DRSACryption alloc]init];
            SecKeyRef pubKey = [DRSACryption publicKeyFromString:publicKey keySize:2048];
            rsaCryption.publicKey = pubKey;
            BOOL result = [rsaCryption rsaSHA256VertifyingString:plainString withSignature:[array firstObject]];
            if (result) {
                // 如果签名验证通过了，开始验证时间
                // 拆分  future 时间
                NSArray *currentTimeSeparatedArray = [lastObjectArrayString componentsSeparatedByString:@"current"];
                NSString *secondLastObjectArrayString = [currentTimeSeparatedArray lastObject]; // lastObject:
                NSArray *timeArray = [secondLastObjectArrayString componentsSeparatedByString:@"future"];
                BOOL timeResult = [DTrailTimeManager compareWithFutureTime:[timeArray lastObject] currentTime:[timeArray firstObject]];
                if (timeResult) {
                    return YES;
                }else{
                    return NO;
                    ACLog(@"超时");
                }
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }
}
#pragma mark - 生成 dat 文件
+ (void)writeLicenseToDiskWithLicenseString:(NSString *)licenseString atPath:(NSString *)licensePath{
    BOOL resultNull = kStringIsEmpty(licensePath);
    if (resultNull) {
        ACLog(@"请传入写文件目录");
    }else{
        // 转换为 data
        NSData *licenseData = [licenseString dataUsingEncoding:NSUTF8StringEncoding];
        // 判断文件
        NSFileManager *manager = [[NSFileManager alloc]init];

        if ([manager fileExistsAtPath:licensePath]) {
            ACLog(@"文件已经存在");
            ACLog(@"准备删除文件");
            [manager removeItemAtPath:licensePath error:nil];
            ACLog(@"已经删除");
            ACLog(@"重新写入");
            // 写入文件
            [licenseData writeToFile:licensePath atomically:YES];
        }else{
            // 写入文件
            [licenseData writeToFile:licensePath atomically:YES];
        }
    }
}

@end
