//
//  KBAppSortingViewController.m
//  KBDOCK
//
//  Created by 开发者  on 2019/3/31.
//  Copyright © 2019年 开发者 . All rights reserved.
//

#import "KBAppSortingViewController.h"
#import "../KBAppManager.h"
#import "UIFont+Extension.h"

#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define TopHeight (IS_iPhoneX?88:64)

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

static NSString *reuseIdentifier = @"sortingApp";
static NSString *bundlePath = @"/Library/PreferenceBundles/KBDockSettings.bundle";

static NSString *sortedPlistPath = @"/var/mobile/Library/Preferences/com.nactro.kbdocksettings.sortedList.plist";
static NSString *originalPlistPath = @"/var/mobile/Library/Preferences/com.nactro.kbdocksettings.list.plist";

@interface KBAppSortingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *sortingTableView;
@property (nonatomic, strong) NSMutableArray *appArray;
@property (nonatomic, strong) UIBarButtonItem *editBtn;
@end

@implementation KBAppSortingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.sortingTableView];
    [self initUI];
    [self initData];
}

- (void)initData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"KBDockUserHaveSortedAppPlist"]) {
    // 从改过的数组里面读取
    self.appArray = [[KBAppManager sharedManager]getSortedAppListArrayFromPath:sortedPlistPath];
    }else{
    // 从原来的 plist 中读取
    self.appArray = [[KBAppManager sharedManager]getAppListToArrayWithAppPlistPath:originalPlistPath];
    }
}

- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"自定义 App 排序";
    self.navigationItem.rightBarButtonItem = self.editBtn;
}

- (void)editButtonOnClicked:(id)sender{
  BOOL canEdit = self.sortingTableView.editing ;
  if (!canEdit) {
      self.sortingTableView.editing = YES;
      self.editBtn.title = @"保存";

  }else{
      self.sortingTableView.editing = NO;
      // 将标题改为 排序
      self.editBtn.title = @"排序";
      // 把排序后的内容写入字典
      [[KBAppManager sharedManager]updateAppListWithNewArray:self.appArray toPath:sortedPlistPath];
      // 保存状态
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      [defaults setBool:YES forKey:@"KBDockUserHaveSortedAppPlist"];
      [defaults synchronize];
  }
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.text = [[KBAppManager sharedManager]getApplicationNameFromDisplayIdentifier:self.appArray[indexPath.row]];
    cell.imageView.image = [[KBAppManager sharedManager]getImageWithDisplayIdentifier:self.appArray[indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.appArray.count;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [self.appArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
		[self.navigationController.navigationController.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"NavBarBG.png"]] forBarMetrics:UIBarMetricsDefault];
		self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
		[self.navigationController.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.title = @"自定义排序应用";
    self.navigationController.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont PingFangMediumForSize:18]};
}

-(void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
		[self.navigationController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
		self.navigationController.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
}

#pragma mark - lazyload
- (UITableView *)sortingTableView{
    if (!_sortingTableView) {
        _sortingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight , kWidth, kHeight -TopHeight) style:UITableViewStyleGrouped];
        [_sortingTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        _sortingTableView.delegate = self;
        _sortingTableView.dataSource = self;
    }
    return _sortingTableView;
}

- (NSMutableArray *)appArray{
    if (!_appArray) {
        _appArray = [NSMutableArray array];
    }
    return _appArray;
}

- (UIBarButtonItem *)editBtn{
    if (!_editBtn) {
        _editBtn = [[UIBarButtonItem alloc]initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonOnClicked:)];
    }
    return _editBtn;
}
@end
