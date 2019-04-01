#include "KBDockRootListController.h"
#include <spawn.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <MessageUI/MessageUI.h>
#import "NactroStickyHeaderView.h"
#import "UIFont+Extension.h"
#import "../Manager/UIDevice+MobileGestaltCategory.h"
#import "../Manager/ACUDIDManager.h"
#import "KBAppSortingViewController.h"

#define mainColor [UIColor colorWithRed:0.36 green:0.38 blue:0.60 alpha:1.0f]
#define HEADER_HEIGHT 180
#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

static NSString *bundlePath = @"/Library/PreferenceBundles/KBDockSettings.bundle";
static NSString *udidPath = @"/var/mobile/Library/nactro/info.dat";
static NSString *sortedPlistPath = @"/var/mobile/Library/Preferences/com.nactro.kbdocksettings.sortedList.plist";
@interface KBDockRootListController()<MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NactroStickyHeaderView *headerView;
@end
@implementation KBDockRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"KBDock" target:self];
	}
	return _specifiers;
}

- (void)viewDidLoad{
	[super viewDidLoad];
	UIImage *icon = [UIImage imageWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"KBDock.png"]];
	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:icon];
	[self writeUDID];
}

- (void)writeUDID{
	[ACUDIDManager writeUDIDToPath:udidPath];
}

/* TableView stuff. */
- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return self.headerView;
	}else{
		return nil;
	}
}

- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return HEADER_HEIGHT;
	} else {
		return [super tableView:tableView heightForHeaderInSection:section];
	}
}

// - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//     CGFloat y = scrollView.contentOffset.y;
//     if (y < - 100) {
// 			UIAlertView *easterEggsAlert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜你发现了这个彩蛋呢 \n 愚人节快乐 \n 🎉" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
// 			[easterEggsAlert show];
//     }
// }

- (void)goSorting{
	KBAppSortingViewController *vc = [[KBAppSortingViewController alloc]init];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)goResetting{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"该功能仅限于您完成过「自定义排序应用」操作，且打算重新添加应用至 Dock 后再进行「自定义排序应用」操作的用户。" preferredStyle:UIAlertControllerStyleActionSheet];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"刷新「自定义排序应用」页面缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults removeObjectForKey:@"KBDockUserHaveSortedAppPlist"];
		[defaults synchronize];

		NSFileManager *manager = [NSFileManager defaultManager];
		if ([manager fileExistsAtPath:sortedPlistPath]){
		//remove
			[manager removeItemAtPath:sortedPlistPath error:nil];
		}
	    }];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消操作" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
	 }];
	    // KVC 改变颜色
	[cancelAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
	[alert addAction:confirmAction];
	[alert addAction:cancelAction];
	[self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 保存plist
- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
		NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
		NSMutableDictionary *settings = [NSMutableDictionary dictionary];
		[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
		[settings setObject:value forKey:specifier.properties[@"key"]];
		[settings writeToFile:path atomically:YES];
}

#pragma mark - Plist 文件中 action 方法实现
- (void)killSpringBoard{
	pid_t pid;
	const char* args[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)openDonate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alipayqr://platformapi/startapp?saId=10000007&qrcode=https://qr.alipay.com/tsx09384ad5mkh65g1irre0"]];
}

- (void)followWeibo{
	NSURL *url;
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
		url = [NSURL URLWithString:@"sinaweibo://userinfo?uid=nactro"];
	}else{
		url = [NSURL URLWithString:@"https://weibo.com/u/nactro"];
	}
	[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void)goFeedback{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc]init];
        picker.mailComposeDelegate = self;
        picker.navigationBar.tintColor = [UIColor blackColor];
        [picker setSubject:@"关于「KBDock插件」我有问题需要反馈……"];
        [picker setMessageBody:@"相关问题：\n \n \n 设备型号：\n \n \n iOS版本：\n \n \n 问题复现方式：\n \n \n 请留下您的联系方式以确保开发者能联系您解决问题。\n 相关联系方式: \n "isHTML:NO];
        [picker setToRecipients:[NSArray arrayWithObjects:@"nactrodev@gmail.com", nil]];
        [self presentViewController:picker animated:YES completion:nil];
    }else{
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"您未设置相关邮件账号"preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
			[alertController addAction:okAction];
			[self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    switch (result) {
        case MFMailComposeResultSent:{
					[self dismissViewControllerAnimated:YES completion:^{
						UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"感谢您的反馈，我们会尽快解决您的问题。"preferredStyle:UIAlertControllerStyleAlert];
						UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
						[alertController addAction:okAction];
						[self.navigationController presentViewController:alertController animated:YES completion:nil];
					}];
				}
            break;
        case MFMailComposeResultFailed:
						[self.navigationController dismissViewControllerAnimated:YES completion:nil];
            break;
        case MFMailComposeResultCancelled:
						[self.navigationController dismissViewControllerAnimated:YES completion:nil];
            break;
        case  MFMailComposeResultSaved:
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

- (void)goAchelper{
	NSURL *url;
	url = [NSURL URLWithString:@"achelper://"];
	[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

-(void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
		[self.navigationController.navigationController.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"NavBarBG.png"]] forBarMetrics:UIBarMetricsDefault];
		self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
		[self.navigationController.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
		[self.navigationController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
		self.navigationController.navigationController.navigationBar.tintColor = nil;
}


#pragma mark - 懒加载
- (NactroStickyHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[NactroStickyHeaderView alloc]initWithDevName:@"Nactro Dev." tweakName:@"快捷键盘" tweakVersion:@"v1.0.3" backgroundColor:mainColor];
        //_headerView.frame = CGRectMake(0, 0, kWidth, HEADER_HEIGHT);
    }
    return _headerView;
}

@end

// Custom Button Cell ----------------------------------------------------------

@interface KBButtonCell : PSTableCell
@end

@implementation KBButtonCell

- (void)layoutSubviews {
		//Sets UIButton Color
		[super layoutSubviews];
		[self.textLabel setTextColor:mainColor];
	}
@end

// Custom Switch Cell ----------------------------------------------------------

@interface KBSwitchCell : PSSwitchTableCell
@end

@implementation KBSwitchCell
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 {
	self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
	if (self) {
		[((UISwitch *)[self control]) setOnTintColor:mainColor];
		//[self.textLabel setTextColor:mainColor];
		self.separatorInset = UIEdgeInsetsZero;
	}
	return self;
}
@end
