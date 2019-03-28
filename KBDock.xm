#import "KBDock.h"
#import "KBDockCollectionView.h"
static NSString *KBDockSettingsPlist = @"/var/mobile/Library/Preferences/com.nactro.kbdocksettings.plist";
static BOOL enabledGlobalSwitch = NO;

static void loadPrefs() {
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:KBDockSettingsPlist];
  if (prefs) {
    enabledGlobalSwitch = ([[prefs objectForKey:@"enabledGlobalSwitch"] boolValue] ? [[prefs objectForKey:@"enabledGlobalSwitch"] boolValue] : enabledGlobalSwitch);
  }
  [prefs release];
}


/* =========================== Hook Dock 栏，添加 App 图标  ===================== */
%hook UIKeyboardDockView
%property (retain, nonatomic) KBDockCollectionView *appDock;

- (instancetype)initWithFrame:(CGRect)frame {
  if (enabledGlobalSwitch) {
  UIKeyboardDockView *dockView = %orig;
    if (dockView) {
      self.appDock = [[KBDockCollectionView alloc]init];
      self.appDock.translatesAutoresizingMaskIntoConstraints = NO;
      [dockView addSubview:self.appDock];

      [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:80]]; // 60
      [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-50]];
      [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
      [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-22]];
    }
    return dockView;
  }else{
    return %orig;
}
}
%end


%ctor {
  loadPrefs();
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.nactro.kbdocksettings/changed"), NULL, CFNotificationSuspensionBehaviorCoalesce);

}
