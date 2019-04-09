#import "KBDock.h"
#import "KBDockCollectionView.h"
#import "Manager/DLicenseManager.h"

#define kWidth [UIScreen mainScreen].bounds.size.width

static NSString *KBDockSettingsPlist = @"/var/mobile/Library/Preferences/com.nactro.kbdocksettings.plist";
static NSString *bundleName = @"com.nactro.kbdock";
static NSString *trialerLicensePath = @"/var/mobile/Library/nactro/trial/com.nactro.kbdock.dat";
static NSString *licensePath = @"/var/mobile/Library/nactro/com.nactro.kbdock.dat";
static NSString *bundlePath = @"/Library/PreferenceBundles/KBDockSettings.bundle";

static NSString *publicKey = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAptsM8G+m3huFQMYqFkV6Ky5TiGqCjE6G3oL9/XSTAkCyQcVQFry17sN5u2s/7YZq0hZZmDpwXE16y2+feUMz4UI9BuS1zr9IiSqoDRKln3amekA7VLfuwuY6ptEJDqRfl114iLvkfXmArThPS7L1G43fFX5HhsblXF6SrQNHr4HHUMlSaGFBW0s5MYK1hLynV/lkn7heE87BEW13D3XwhVhHTNboZ9tABpStMbTHRUxB1Mjb79TjB0qFUvC7VP57Rd5DzO++GQwdAniKYTisJ5ZPoN9yY7dGoSWhYBz3Te7dlcCNzzSVXDrAvjvXNdkuZvf2iA8FS85QTl3IKIoHLQIDAQAB";


static BOOL enabledGlobalSwitch = NO;
static BOOL licenseStatus = NO;

static void loadPrefs() {
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:KBDockSettingsPlist];
  if (prefs) {
    enabledGlobalSwitch = ([[prefs objectForKey:@"enabledGlobalSwitch"] boolValue] ? [[prefs objectForKey:@"enabledGlobalSwitch"] boolValue] : enabledGlobalSwitch);
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

- (instancetype)initWithFrame:(CGRect)frame {
    //licenseStatus = YES;
    UIKeyboardDockView *dockView = %orig;
    //licenseStatus &&
    if (enabledGlobalSwitch) {

      if (dockView) {
        self.appDock = [[KBDockCollectionView alloc]init];
        self.appDock.translatesAutoresizingMaskIntoConstraints = NO;
        [dockView addSubview:self.appDock];

        [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:80]]; // 60
        [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-50]];
        [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
        [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-22]];

        UIButton *pasteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pasteBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"paste.png"]] forState:UIControlStateNormal];
        pasteBtn.frame = CGRectMake(310,225,30,30);
        [pasteBtn addTarget:self action:@selector(pasteBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [dockView addSubview:pasteBtn];
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
  %orig(nil);
}

%new
- (void)pasteBtnButtonClick:(id)sender{
  NSLog(@"pasteBtnButtonClick:");
}

%end




%ctor {
  verifySignature();
  loadPrefs();
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.nactro.kbdocksettings/changed"), NULL, CFNotificationSuspensionBehaviorCoalesce);

}
