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
#import "UIImpactFeedbackGenerator+Feedback.h"

static NSString *appListPlist = @"/var/mobile/Library/Preferences/com.nactro.kbdocksettings.list.plist";
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
      BOOL appOpenStatus = [[appListDict objectForKey:displayIdentifier]boolValue];
      if (appOpenStatus) {
        [self.appListArr addObject:displayIdentifier];
      }
    }
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KBDockCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KBDock" forIndexPath:indexPath];
    // 打印出来是 com.apple.mobilenotes
    //NSLog(@"self.appListArr[indexPath.section]%@",self.appListArr[indexPath.section]);
    //NSString *bundleIdentifier = self.appListArr[indexPath.section];
    // 正常
    //cell.appImageView.image = [[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:bundleIdentifier];
    // crash
    //cell.appImageView.image = [[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:self.appListArr[indexPath.section]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.appListArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(30, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [UIImpactFeedbackGenerator generateFeedbackWithLightStyle];
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
