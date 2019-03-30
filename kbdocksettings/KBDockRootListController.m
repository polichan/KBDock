#include "KBDockRootListController.h"
#include <spawn.h>
#import <MessageUI/MessageUI.h>
#import "NactroStickyHeaderView.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

static NSString *bundlePath = @"/Library/PreferenceBundles/KBDockSettings.bundle";

@interface KBDockRootListController()<MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NactroStickyHeaderView *headerView;
@end
@implementation KBDockRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"KBDock" target:self];
		[self loadHeaderView];
	}

	return _specifiers;
}

- (void)loadHeaderView{
	[self.view addSubview:self.headerView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y < 0) {
        self.headerView.frame = CGRectMake(0, y, kWidth, 180 + 2 * fabs(y));
    }
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

- (void)followWeibo{
	NSURL *url;
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
		url = [NSURL URLWithString:@"sinaweibo://userinfo?uid=nactro"];
	}else{
		url = [NSURL URLWithString:@"https://weibo.com/u/nactro"];
	}
	[[UIApplication sharedApplication] openURL:url];
}

- (void)goFeedback{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc]init];
        picker.mailComposeDelegate = self;
        picker.navigationBar.tintColor = [UIColor blackColor];
        [picker setSubject:@"关于「ReTime插件」我有问题需要反馈……"];
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

#pragma mark - 懒加载
- (NactroStickyHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[NactroStickyHeaderView alloc]initWithDevName:@"Nactro Dev." tweakName:@"快捷键盘" tweakVersion:@"v1.0.0" backgroundColor:[UIColor colorWithRed:0.36 green:0.38 blue:0.60 alpha:1.0f]];
        _headerView.frame = CGRectMake(0, 0, kWidth, 180);
    }
    return _headerView;
}
@end
