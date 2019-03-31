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
#import "UIDevice+MobileGestaltCategory.h"
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

+ (BOOL)verifyLicenseFromPath:(NSString *)licenseFilePath publicKey:(NSString *)publicKey bundleName:(NSString *)bundleName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL licenFilePathExist = kStringIsEmpty(licenseFilePath);
    if (licenFilePathExist) {
        ACLog(@"请传入文件路径");
        return NO;
    }else{
        if ([fileManager fileExistsAtPath:licenseFilePath]) {
            NSData *data = [NSData dataWithContentsOfFile:licenseFilePath];
            NSString *wrappedLicense = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            // Hex 转 String
            NSString *convertToString = [ACHexManager stringFromHexString:wrappedLicense];
            ACLog(@"convertToString--->%@",convertToString);
            // 解析 String 去除 连接符
            NSArray *nactroSymbolArray = [convertToString componentsSeparatedByString:@"official"];
            ACLog(@"nactroSymbolArray--->%@",nactroSymbolArray);
            /* nactroSymbolArray[firstObject]:
             W0Nh7w2AIbw2AD7frUPvmFCzYYxgZJXSdP59lssmnN1P8+BAxa2X6vdCWbJSwxE4KbwX1GRdBF9G/uhd0C/LF/xzzYICjkcf0S4JolgTwfT9phqZDkxHDCljNG4qaa3xT/A4+aFs9UTftqzrcSLsQazRrBqA2kNgCue7PKvjvgRGXunh4jN2HCSw5WeaNDX8sULmtKZvwc47WV6guYTSMgrJ/md3XoxsXGg/rrIpNKsb1IKstAagXSBIQGfxic5le3J7bkf9QK1SwDwLIEu1A9sfNI++N+bZt2ITRmAAJwy42cth8rEI77WifAmDnofI/GegB1dLOBnAKxnhvRAjPg==
             */
            // nactroSymbolArray[lastObject] :
            /* com.nactro.retime
             bundleSymbol
             IsnHds25p3TNVirJ
             activationSymbol 70b1bcf334d1b7a4d4753f9ccdb84628c85084e1 udidSymbol
             1554001309
             */
            NSString *licenseWithSymbolString = [nactroSymbolArray lastObject];
            ACLog(@"licenseWithSymbolString----->%@",licenseWithSymbolString);
            NSString *noBundleSymbol  = [licenseWithSymbolString stringByReplacingOccurrencesOfString:@"bundleSymbol" withString:@""];
            NSString *noActivationSymbol = [noBundleSymbol stringByReplacingOccurrencesOfString:@"activationSymbol" withString:@""];
            NSString *noUDIDSymbol = [noActivationSymbol stringByReplacingOccurrencesOfString:@"udidSymbol" withString:@""];
            NSString *licenseWithoutSymbolString = noUDIDSymbol;
            ACLog(@"licenseWithoutSymbolString----->%@",licenseWithoutSymbolString);
            // 判读包名
            NSString *nactroSymbolArrayLastObject = [nactroSymbolArray lastObject];
            /*
             com.nactro.retime
             bundleSymbol
             IsnHds25p3TNVirJ
             activationSymbol
             70b1bcf334d1b7a4d4753f9ccdb84628c85084e1
             udidSymbol
             1554001309
             */
            NSArray *bundleSymbolArray = [nactroSymbolArrayLastObject componentsSeparatedByString:@"bundleSymbol"];
            ACLog(@"bundleSymbolArray--->%@",bundleSymbolArray);
            /*
             bundleSymbolArray firstObject :com.nactro.retime
             bundleSymbolArray lastObject :

             IsnHds25p3TNVirJ
             activationSymbol
             70b1bcf334d1b7a4d4753f9ccdb84628c85084e1
             udidSymbol
             1554001309

             */

            NSString *bundleInSymbolArray = [bundleSymbolArray firstObject];
            ACLog(@"bundleInSymbolArray--->%@",bundleInSymbolArray);
            if ([bundleName isEqualToString:bundleInSymbolArray]) {
                ACLog(@"证书文件内包名:%@ 与本地包名:%@ ",bundleInSymbolArray,bundleName);
                // 如果包名字相同
                // 接着判断 UDID
                NSArray *activationCodeSymbolArray = [nactroSymbolArrayLastObject componentsSeparatedByString:@"activationSymbol"];
                ACLog(@"activationCodeSymbolArray--->%@",activationCodeSymbolArray);
                /*
                 activationCodeSymbolArray first Object : IsnHds25p3TNVirJ
                 activationCodeSymbolArray last Object :

                 70b1bcf334d1b7a4d4753f9ccdb84628c85084e1
                 udidSymbol
                 1554001309
                 */
                NSArray *udidSymbolArray = [[activationCodeSymbolArray lastObject]componentsSeparatedByString:@"udidSymbol"];
                ACLog(@"udidSymbolArray--->%@",udidSymbolArray);
                NSString *udidInUdidSymbolArray = [udidSymbolArray firstObject];
                NSString *localUDID = [[UIDevice currentDevice]UDID];
                //NSString *localUDID = @"70b1bcf334d1b7a4d4753f9ccdb84628c85084e1";
                if ([localUDID isEqualToString:udidInUdidSymbolArray]) {
                    // UDID 验证通过，开始验证签名
                    ACLog(@"证书文件内UDID:%@ 与本地UDID:%@ ",udidInUdidSymbolArray,localUDID);
                    DRSACryption *rsaCryption = [[DRSACryption alloc]init];
                    SecKeyRef pubKey = [DRSACryption publicKeyFromString:publicKey keySize:2048];
                    rsaCryption.publicKey = pubKey;
                    BOOL licenseVerifyResult = [rsaCryption rsaSHA256VertifyingString:licenseWithoutSymbolString withSignature:[nactroSymbolArray firstObject]];
                    if (licenseVerifyResult) {
                        ACLog(@"证书文件校验通过，正式激活");
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return NO;
                }
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }

}

+ (BOOL)verifyTrailerLicenseFromPath:(NSString *)trailerLicensePath publicKey:(NSString *)publicKey bundleName:(NSString *)bundleName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL resultNull = kStringIsEmpty(trailerLicensePath);
    if (!resultNull) {
        // 是否存在此文件
        if ([fileManager fileExistsAtPath:trailerLicensePath]) {
            // 如果存在，开始验证
            NSData *data = [NSData dataWithContentsOfFile:trailerLicensePath];
            NSString *wrappedLicense = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            // Hex 转 String
            NSString *convertToString = [ACHexManager stringFromHexString:wrappedLicense];
            // 解析 String 去除 连接符 trial
            NSArray *trialArray = [convertToString componentsSeparatedByString:@"trial"];
            ACLog(@"trialArray--->%@",trialArray);
            // 1
            NSString *licenseWithTagString = [trialArray lastObject];
            NSString *noCurrentTag = [licenseWithTagString stringByReplacingOccurrencesOfString:@"currentTag" withString:@""];
            NSString *noPackageTag = [noCurrentTag stringByReplacingOccurrencesOfString:@"packageTag" withString:@""];
            NSString *noUDIDTag = [noPackageTag stringByReplacingOccurrencesOfString:@"udidTag" withString:@""];
            NSString *licenseWithoutTagString = noUDIDTag;

            ACLog(@"licenseWithoutTagString--->%@",licenseWithoutTagString);

            NSArray *packageArray = [[trialArray lastObject] componentsSeparatedByString:@"packageTag"];

            ACLog(@"packageArray--->%@",packageArray);

            NSString *packageInPackageArray = [packageArray firstObject];
            if ([packageInPackageArray isEqualToString:bundleName]) {
                ACLog(@"包名验证通过");
                // 包名验证通过
                // 开始验证 UDID
                NSArray *udidArray = [[packageArray lastObject]componentsSeparatedByString:@"udidTag"];
                ACLog(@"udidArray--->%@",udidArray);
                //3
                NSString *udidInUdidArray = [udidArray firstObject];
                ACLog(@"udidInUdidArray--->%@",udidInUdidArray);
                NSString *udid = @"70b1bcf334d1b7a4d4753f9ccdb84628c85084e1";
                //if ([udidInUdidArray isEqualToString:[[UIDevice currentDevice]UDID]]) {
                if ([udidInUdidArray isEqualToString:udid]) {
                    ACLog(@"UDID验证通过");
                    // UDID 验证通过
                    //开始验证时间
                    NSArray *timeArray = [[udidArray lastObject]componentsSeparatedByString:@"currentTag"];
                    /*
                     timeArray firstObject:1554004770
                     last Object :1554263970
                     */
                    BOOL timeResult = [DTrailTimeManager compareWithFutureTime:[timeArray lastObject] currentTime:[timeArray firstObject]];
                    if (timeResult) {
                        ACLog(@"仍然在试用期内");
                        // 如果没有过期,开始验证全部签名
                        DRSACryption *rsaCryption = [[DRSACryption alloc]init];
                        SecKeyRef pubKey = [DRSACryption publicKeyFromString:publicKey keySize:2048];
                        rsaCryption.publicKey = pubKey;
                        BOOL result = [rsaCryption rsaSHA256VertifyingString:licenseWithoutTagString withSignature:[trialArray firstObject]];
                        if (result) {
                            // 签名验证通过
                            ACLog(@"签名验证通过");
                            return YES;
                        }else{
                            return NO;
                        }
                    }else{
                        ACLog(@"不在试用期内");
                        return NO;
                    }
                }else{
                    return NO;
                }
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }else{
        return NO;
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
