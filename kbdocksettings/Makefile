GO_EASY_ON_ME = 1

ifeq ($(SIMJECT),1)
TARGET = simulator:clang:11.2:8.0
ARCHS = x86_64 i386
KBDockSettings_CFLAGS += -D SIMJECT=1
else
TARGET = iphone:clang:11.2:11.0
ARCHS = arm64
# SDKVERSION = 11.2
# SYSROOT = $(THEOS)/sdks/iPhoneOS11.2.sdk
endif

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = KBDockSettings
KBDockSettings_FILES = ../Common.mm ../KBAppManager.m $(wildcard *.m ../Manager/*.m NactroCreditClasses/*.m)

KBDockSettings_INSTALL_PATH = /Library/PreferenceBundles
KBDockSettings_FRAMEWORKS = UIKit Foundation CoreFoundation
KBDockSettings_LIBRARIES = applist MobileGestalt
KBDockSettings_PRIVATE_FRAMEWORKS = Preferences AppSupport
KBDockSettings_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/KBDockSettings.plist$(ECHO_END)
