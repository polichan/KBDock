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
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

static NSString *reuseIdentifier = @"sortingApp";
static NSString *path = @"/var/mobile/Library/Preferences/com.nactro.kbdocksettings.list.plist";
static NSString *bundlePath = @"/Library/PreferenceBundles/KBDockSettings.bundle";
@interface KBAppSortingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *sortingTableView;
@property (nonatomic, strong) NSMutableArray *appArray;
@property (nonatomic, strong) UIBarButtonItem *editBtn;
@end

@implementation KBAppSortingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.sortingTableView];
    NSLog(@"run here --->");
    // [self initUI];
    // [self initData];
}
// - (id)specifiers {
// 	if (!_specifiers) {
//
// 		PSSpecifier* testSpecifier = [PSSpecifier preferenceSpecifierNamed:@"test"
// 									    target:self
// 									       set:NULL
// 									       get:NULL
// 									    detail:Nil
// 									      cell:PSTitleValueCell
// 									      edit:nil];
// 		_specifiers = [NSArray arrayWithObjects:testSpecifier, nil];
// 	}
// 	return _specifiers;
// }

// - (void)initData{
//   //  self.appArray = [[KBAppManager sharedManager]getAppListToArrayWithAppPlistPath:path];
//   //  NSLog(@"self.appArray ----> %@",self.appArray);
// }
//
// - (void)initUI{
//     self.view.backgroundColor = [UIColor whiteColor];
//     self.navigationItem.title = @"自定义 App 排序";
//     self.navigationItem.rightBarButtonItem = self.editBtn;
// }
//
// #pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    //cell.textLabel.text = self.appArray[indexPath.row];
    return cell;
}
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  //  return self.appArray.count;
    return 1;
}
//
// - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
//     // [self.appArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
//     // NSLog(@"self.appArrayWithSoring ----> %@",self.appArray);
// }
//
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
//
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
// - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//     [tableView deselectRowAtIndexPath:indexPath animated:YES];
// }

-(void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
		[self.navigationController.navigationController.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"NavBarBG.png"]] forBarMetrics:UIBarMetricsDefault];
		self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
		[self.navigationController.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.title = @"排序应用";
    self.navigationController.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont PingFangMediumForSize:18]};
}

-(void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
		[self.navigationController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
		self.navigationController.navigationController.navigationBar.tintColor = nil;
}

#pragma mark - lazyload


- (UITableView *)sortingTableView{
    if (!_sortingTableView) {
        _sortingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
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
