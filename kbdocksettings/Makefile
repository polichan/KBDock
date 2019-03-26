GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk
ARCHS = arm64
SDKVERSION = 11.2
SYSROOT = $(THEOS)/sdks/iPhoneOS11.2.sdk

BUNDLE_NAME = KBDockSettings
KBDockSettings_FILES = KBDockRootListController.m KBApplicationController.m NactroCreditClasses/NactroCreditOption.m  NactroCreditClasses/NactroCreditService.m  NactroCreditClasses/NactroCreditCell.m
KBDockSettings_INSTALL_PATH = /Library/PreferenceBundles
KBDockSettings_FRAMEWORKS = UIKit Foundation CoreFoundation
KBDockSettings_LIBRARIES = applist
KBDockSettings_PRIVATE_FRAMEWORKS = Preferences
KBDockSettings_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/KBDockSettings.plist$(ECHO_END)
