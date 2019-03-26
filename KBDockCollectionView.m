//
//  KBDockCollectionView.m
//  KBDock
//
//  Created by 陈鹏宇  on 2019/3/26.
//  Copyright © 2019年 陈鹏宇 . All rights reserved.
//

#import "KBDockCollectionView.h"
#import "KBDockCollectionViewCell.h"


@interface KBDockCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *recentEmojis;
@property (nonatomic, strong) KBDockCollectionViewCell *appCollectionCell;
@end

@implementation KBDockCollectionView
- (instancetype)init {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.minimumLineSpacing = 0;

    if(self = [super initWithFrame:CGRectZero collectionViewLayout:flowLayout]) {
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        [self registerClass:NSClassFromString(@"KBDockCollectionViewCell") forCellWithReuseIdentifier:@"KBDock"];
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KBDockCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KBDock" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(30, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击");
}
@end
