//
//  KBDockCollectionView.m
//  KBDock
//
//  Created by 陈鹏宇  on 2019/3/26.
//  Copyright © 2019年 陈鹏宇 . All rights reserved.
//

#import "KBDockCollectionView.h"
#import "KBDockCollectionViewCell.h"
#import <AppList/AppList.h>
#import "KBApplicationModel.h"

static NSString *appListPlist = @"/var/mobile/Library/Preferences/com.nactro.kbdocksettings.applist.plist";
static NSString *bundlePath = @"/var/mobile/nactro";
static LSApplicationWorkspace* workspace = [NSClassFromString(@"LSApplicationWorkspace") new];

@interface KBDockCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) KBDockCollectionViewCell *appCollectionCell;
@property (nonatomic, strong) NSMutableArray *appListArr;
@end

@implementation KBDockCollectionView
- (instancetype)init {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 15;

    if(self = [super initWithFrame:CGRectZero collectionViewLayout:flowLayout]) {
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        [self registerClass:NSClassFromString(@"KBDockCollectionViewCell") forCellWithReuseIdentifier:@"KBDock"];
        self.backgroundColor = [UIColor clearColor];

        [self updateAppArr];
    }
    return self;
}
#pragma mark - 更新 App 数组
- (void)updateAppArr{
    NSDictionary *appListDict= [NSDictionary dictionaryWithContentsOfFile:appListPlist];
    for (NSString *displayIdentifier in appListDict) {
      NSLog(@"包名：%@ 对应的属性为%@",displayIdentifier,[appListDict objectForKey:displayIdentifier]);
      BOOL appOpenStatus = [[appListDict objectForKey:displayIdentifier]boolValue];
      if (appOpenStatus) {
        NSLog(@"包名：%@开启",displayIdentifier);
        // 获取图片
        UIImage *icon = [[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:displayIdentifier];
        // 拼接路径
        NSString *iconPath = [[bundlePath stringByAppendingPathComponent:displayIdentifier] stringByAppendingString:@".png"];
        NSLog(@"iconPath --->%@",iconPath);
        KBApplicationModel *model = [[KBApplicationModel alloc]initWithDisplayIdentifier:displayIdentifier iconPath:iconPath];
        // 存入图片数组
        BOOL result = [UIImagePNGRepresentation(icon)writeToFile:iconPath atomically:YES];
        if (result) {
          [self.appListArr addObject:model];
        }else{
          NSLog(@"写入失败");
        }
      }
    }
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KBDockCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KBDock" forIndexPath:indexPath];
    cell.appImageView.image = [UIImage imageWithContentsOfFile:[self.appListArr]indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.appListArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(30, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [workspace openApplicationWithBundleID:@"com.apple.Preferences"];
    });
}

#pragma mark - lazyload

- (NSMutableArray *)appListArr{
    if (!_appListArr) {
        _appListArr = [NSMutableArray array];
    }
    return _appListArr;
}
@end
