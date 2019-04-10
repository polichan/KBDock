//
//  KBDockClipBoardTableViewController.m
//  kbdock
//
//  Created by 开发者  on 2019/4/10.
//  Copyright © 2019年 Nactro. All rights reserved.
//

#import "KBDockClipBoardViewController.h"
#import "UIColor+Hex.h"
#import "UIImpactFeedbackGenerator+Feedback.h"
#import "kbdocksettings/UIFont+Extension.h"

static NSString *reuseIdentifier = @"kbdockClipBoard";

@interface KBDockClipBoardViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *clipBoardArray;
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) UIVisualEffectView *backgroundView;
@property (nonatomic, strong) UIView *darkeningView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITapGestureRecognizer *closeGestureRecogniser;
@end

@implementation KBDockClipBoardViewController

#pragma mark - overide init method
- (instancetype)initWithViewFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.contentView = [[UIView alloc]initWithFrame:frame];
        self.contentView.clipsToBounds = YES;
        self.contentView.layer.cornerRadius = 12.5;
        [self.contentView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [self.contentView.layer setBorderWidth:0.8f];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.userInteractionEnabled = YES;
        [self.view addSubview:self.contentView];
    }
    return self;
}

#pragma mark - Class methods

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.backgroundView.contentView.userInteractionEnabled = YES;

    [self.view addSubview:self.backgroundView];


    self.darkeningView = [[UIView alloc] initWithFrame:CGRectZero];
    self.darkeningView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.darkeningView.userInteractionEnabled = NO;

    [self.backgroundView.contentView addSubview:self.darkeningView];

    self.tableView.frame = self.contentView.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.contentView addSubview:self.tableView];

    self.backgroundView.frame = self.view.bounds;
    self.darkeningView.frame = self.backgroundView.bounds;

    self.closeGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_userDidTapCloseButton:)];
    [self.backgroundView.contentView addGestureRecognizer:self.closeGestureRecogniser];

    [self initData];
}

- (void)initData{
  // handle data
}

- (void)_userDidTapCloseButton:(id)button {
    // animate out, and hide.
    [self animateForDismissalWithCompletion:^{
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }];
}

- (void)_userDidFinishPasting{
    [self animateForDismissalWithCompletion:^{
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.font = [UIFont PingFangRegularForSize:18];
    //cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#006fff"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"test";
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIImpactFeedbackGenerator generateFeedbackWithLightStyle];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self _userDidFinishPasting];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //[cell setSeparatorInset:UIEdgeInsetsMake(0, 5, 0, 5)];
    [cell setSeparatorInset:UIEdgeInsetsZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - 页面出现动画
- (void)animateForPresentation {
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.view.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.view.alpha = 0.0;
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.765
          initialSpringVelocity:0.15
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.alpha = 1.0;
                         self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.view.frame.size.height/2 - self.contentView.frame.size.height/2, self.contentView.frame.size.width, self.contentView.frame.size.height);
                     } completion:^(BOOL finished) {

                     }];
}

#pragma mark - 页面消失动画
- (void)animateForDismissalWithCompletion:(void (^)(void))completionHandler {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.alpha = 0.0;
                         self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.view.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);

                             completionHandler();
                         }
                     }];
}

#pragma mark - lazyload
- (NSMutableArray *)clipBoardArray{
    if (!_clipBoardArray) {
        _clipBoardArray = [NSMutableArray array];
    }
    return _clipBoardArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        //[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.separatorColor = [UIColor whiteColor];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView setTableHeaderView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.01, 0.01)]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}
@end
