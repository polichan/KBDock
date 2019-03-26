#include "KBDockRootListController.h"
#import  <AppList/AppList.h>
#include <spawn.h>
#import <MessageUI/MessageUI.h>

@interface KBDockRootListController()<MFMailComposeViewControllerDelegate>
@end
@implementation KBDockRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

#pragma mark - 保存plist
- (id)readPreferenceValue:(PSSpecifier*)specifier {
	//NSString *path = [NSString stringWithFormat:userPath(@"/var/mobile/Library/Preferences/%@.plist"), specifier.properties[@"defaults"]];
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

#pragma mark - RetTimePlist 文件中 action 方法实现
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

@end
