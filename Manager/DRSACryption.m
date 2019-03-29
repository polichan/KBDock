//
//  DRSACryption.m
//  DObject
//
//  Created by 陈鹏宇 on 2019/3/6.
//  Copyright © 2019年 陈鹏宇. All rights reserved.
//

#import "DRSACryption.h"
#import <CommonCrypto/CommonCrypto.h>
#import <Security/Security.h>
#import "../KBDockMacro.h"

@interface DRSACryption()
@end
@implementation DRSACryption


+ (SecKeyRef )publicKeyFromString:(NSString *)publicKey keySize:(size_t )size
{
    SecKeyRef pubkeyref;
    NSError *readFErr = nil;
    CFErrorRef errref = noErr;
    NSAssert(readFErr==nil, @"pem文件加载失败");
    NSData *dataPubKey = [[NSData alloc]initWithBase64EncodedString:publicKey options:0];

    NSMutableDictionary *dicPubkey = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dicPubkey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [dicPubkey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)kSecAttrKeyClass];
    [dicPubkey setObject:@(size) forKey:(__bridge id)kSecAttrKeySizeInBits];

    pubkeyref = SecKeyCreateWithData((__bridge CFDataRef)dataPubKey, (__bridge CFDictionaryRef)dicPubkey, &errref);

    NSAssert(errref==noErr, @"公钥加载错误");

    return pubkeyref;
}

- (SecKeyRef)getPublicKey {
    return self.publicKey;
}


- (BOOL)rsaSHA256VertifyingString:(NSString *)plainString withSignature:(NSString *)signature {
    SecKeyRef publicKey = [self getPublicKey];
    return [self rsaSHA256VertifyingData:plainString withSignature:signature publicKey:publicKey];
}

- (BOOL)rsaSHA256VertifyingData:(NSString *)plainString withSignature:(NSString *)signatureString publicKey:(SecKeyRef)publicKey {
    if (!publicKey) {
        NSLog(@"请传入publicKey");
    }
    NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signature = [[NSData alloc]initWithBase64EncodedString:signatureString options:0];
    size_t signedHashBytesSize = SecKeyGetBlockSize(publicKey);
    const void* signedHashBytes = [signature bytes];

    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return NO;
    }

    OSStatus status = SecKeyRawVerify(publicKey,
                                      kSecPaddingPKCS1SHA256,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);

    return status == errSecSuccess;
}
@end
