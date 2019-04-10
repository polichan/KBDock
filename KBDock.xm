#import "KBDock.h"
#import "KBDockCollectionView.h"
#import "Manager/DLicenseManager.h"
#import "KBDockMacro.h"
#import "KBDockClipBoardViewController.h"
#import <objc/runtime.h>
#import "UIView+Extend.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kTopWindow [[UIApplication sharedApplication]keyWindow]

static NSString *KBDockSettingsPlist = @"/var/mobile/Library/Preferences/com.nactro.kbdocksettings.plist";
static NSString *bundleName = @"com.nactro.kbdock";
static NSString *trialerLicensePath = @"/var/mobile/Library/nactro/trial/com.nactro.kbdock.dat";
static NSString *licensePath = @"/var/mobile/Library/nactro/com.nactro.kbdock.dat";
static NSString *bundlePath = @"/Library/PreferenceBundles/KBDockSettings.bundle";

static NSString *publicKey = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAptsM8G+m3huFQMYqFkV6Ky5TiGqCjE6G3oL9/XSTAkCyQcVQFry17sN5u2s/7YZq0hZZmDpwXE16y2+feUMz4UI9BuS1zr9IiSqoDRKln3amekA7VLfuwuY6ptEJDqRfl114iLvkfXmArThPS7L1G43fFX5HhsblXF6SrQNHr4HHUMlSaGFBW0s5MYK1hLynV/lkn7heE87BEW13D3XwhVhHTNboZ9tABpStMbTHRUxB1Mjb79TjB0qFUvC7VP57Rd5DzO++GQwdAniKYTisJ5ZPoN9yY7dGoSWhYBz3Te7dlcCNzzSVXDrAvjvXNdkuZvf2iA8FS85QTl3IKIoHLQIDAQAB";

static BOOL enabledClipBoradSwitch = NO;
static BOOL enabledGlobalSwitch = NO;
static BOOL licenseStatus = NO;

static void loadPrefs() {
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:KBDockSettingsPlist];
  if (prefs) {
    enabledGlobalSwitch = ([[prefs objectForKey:@"enabledGlobalSwitch"] boolValue] ? [[prefs objectForKey:@"enabledGlobalSwitch"] boolValue] : enabledGlobalSwitch);
    enabledClipBoradSwitch = ([[prefs objectForKey:@"enabledClipBoradSwitch"] boolValue] ? [[prefs objectForKey:@"enabledClipBoradSwitch"] boolValue] : enabledClipBoradSwitch);
  }
  [prefs release];
}

static void verifySignature(){
  NSFileManager *fileManager = [NSFileManager defaultManager];
  // 首先判断有没有试用文件
  if([fileManager fileExistsAtPath:licensePath] && [fileManager fileExistsAtPath:trialerLicensePath]){  // 同时存在有先判断正式激活文件
    // 如果存在，就验证文件
    BOOL result = [DLicenseManager verifyLicenseFromPath:licensePath publicKey:publicKey bundleName:bundleName];
    if (result) {
      licenseStatus = YES;
    }else{
      licenseStatus = NO;
    }
  }else if([fileManager fileExistsAtPath:licensePath]){ //判断正式激活文件是否存在
    // 存在则验证
    BOOL result = [DLicenseManager verifyLicenseFromPath:licensePath publicKey:publicKey bundleName:bundleName];
    if (result) {
      licenseStatus = YES;
    }else{
      licenseStatus = NO;
    }
  }else if([fileManager fileExistsAtPath:trialerLicensePath]){
    BOOL trial = [DLicenseManager verifyTrailerLicenseFromPath:trialerLicensePath publicKey:publicKey bundleName:bundleName];
    if (trial) {
      licenseStatus = YES;
    }else{
      licenseStatus = NO;
    }
}else{
  licenseStatus = NO;
}
}

/* =========================== Hook Dock 栏，添加 App 图标  ===================== */
%hook UIKeyboardDockView
%property (retain, nonatomic) KBDockCollectionView *appDock;
%property (retain, nonatomic) UIButton *clipBoardBtn;
- (instancetype)initWithFrame:(CGRect)frame {
    //licenseStatus = YES;
    UIKeyboardDockView *dockView = %orig;
    //licenseStatus &&
    if (enabledGlobalSwitch) {

      if (dockView) {
        self.appDock = [[KBDockCollectionView alloc]init];
        self.appDock.translatesAutoresizingMaskIntoConstraints = NO;
        [dockView addSubview:self.appDock];

        [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:73]]; // 60
        [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-58]];
        [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
        [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-22]];

        if (enabledClipBoradSwitch){
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbDidGetNotifOfStandardGlyphColor:) name:@"kbDidChangeStandardGlyphColor" object:nil];
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbDidGetNotifOfDarkGlyphColor:) name:@"kbDidChangeDarkStyleGlyphColor" object:nil];

          self.clipBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
          self.clipBoardBtn.translatesAutoresizingMaskIntoConstraints = NO;
          [self.clipBoardBtn addTarget:self action:@selector(clipBoardBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
          UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clipBoardButtonLongPress:)];
          [self.clipBoardBtn addGestureRecognizer:longPress];

          [dockView addSubview:self.clipBoardBtn];

          [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.clipBoardBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15]];
          [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.clipBoardBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35]];
          [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.clipBoardBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35]];
          [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.clipBoardBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-27]];

        }

        return dockView;
      }else{
        return %orig;
      }
    }else{
      return %orig;
    }
}
/* =========================== Hook Dock 栏听写键，去除听写键  ===================== */
- (void)setRightDockItem:(UIKeyboardDockItem *)arg1{
  if (enabledClipBoradSwitch) {
    %orig(nil);
  }else{
    %orig;
  }
}
/* =========================== 移除通知 ===================== */
- (void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  %orig;
}
/* =========================== 黏贴文本方法  ===================== */
%new
- (void)clipBoardBtnButtonClick:(id)sender{
  KBDockClipBoardViewController *vc = [[KBDockClipBoardViewController alloc]initWithViewFrame:CGRectMake(10,0,375 - 10 *2 ,400)];
  vc.view.alpha = 0.0;
  UIViewController *inputVC = [self viewController];
  NSLog(@"dockView所在的控制器------>%@ ------>%f -------->%f",inputVC,inputVC.view.frame.size.height,inputVC.view.frame.size.width);
  [inputVC.view addSubview:vc.view];
  [vc animateForPresentation];
}

%new
- (void)clipBoardButtonLongPress:(UILongPressGestureRecognizer *)longPress{
  UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
  [[NSClassFromString(@"UIKeyboardImpl") activeInstance] insertText:pasteBoard.string];
}

/* =========================== 通知响应方法  ===================== */
%new
- (void)kbDidGetNotifOfStandardGlyphColor:(NSNotification *)notif{
    NSString *imagePath = notif.userInfo[@"image"];
    [self.clipBoardBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
}
%new
- (void)kbDidGetNotifOfDarkGlyphColor:(NSNotification *)notif{
  NSString *imagePath = notif.userInfo[@"image"];
  [self.clipBoardBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
}

%end
/*
* 注意，Apple 所定义的 standard 指的是 UIDock 的颜色，即「白灰色」，因此，图片需要变为 dark
* 同理
*/
%hook UIKeyboardDockItem
+ (id)_standardGlyphColor{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"kbDidChangeStandardGlyphColor" object:nil userInfo:@{@"image":[bundlePath stringByAppendingPathComponent:@"pasteDark.png"]}];
  return %orig;
}

+ (id)_darkStyleGlyphColor{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"kbDidChangeDarkStyleGlyphColor" object:nil userInfo:@{@"image":[bundlePath stringByAppendingPathComponent:@"pasteStandard.png"]}];
  return %orig;
}
%end
/* =========================== UIPasteboard  ===================== */
%hook UIPasteboard
- (void)setString:(NSString *)arg1{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"kbDidSetString" object:nil userInfo:@{@"string":arg1}];
  %orig;
}
%end

%ctor {
  //verifySignature();
  loadPrefs();
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.nactro.kbdocksettings/changed"), NULL, CFNotificationSuspensionBehaviorCoalesce);

}
