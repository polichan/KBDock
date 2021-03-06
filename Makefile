GO_EASY_ON_ME = 1
DEBUG = 0
ifeq ($(SIMJECT),1)
TARGET = simulator:clang:11.2:8.0
ARCHS = x86_64 i386
KBDock_CFLAGS += -D SIMJECT=1
else
TARGET = iphone:clang:11.2:11.0
ARCHS = arm64
THEOS=/opt/theos
# SDKVERSION = 11.2
# SYSROOT = $(THEOS)/sdks/iPhoneOS11.2.sdk
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KBDock
# KBDock_LIBRARIES = sparkapplist
KBDock_FILES = KBDock.xm Common.mm KBDockCollectionView.mm kbdocksettings/UIFont+Extension.m $(wildcard *.m Manager/*.m)
KBDock_LDFLAGS = -lMobileGestalt
KBDock_FRAMEWORKS = CoreFoundation UIKit
KBDock_LIBRARIES = applist
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += kbdocksettings
include $(THEOS_MAKE_PATH)/aggregate.mk


ifneq (,$(filter x86_64 i386,$(ARCHS)))
include ../preferenceloader/locatesim.mk
BUNDLE_NAME = KBDockSettings

setup:: all
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
	@sudo cp -v $(PWD)/$(BUNDLE_NAME)/entry.plist $(PL_SIMULATOR_PLISTS_PATH)/$(BUNDLE_NAME).plist
	@sudo rm -rf $(PL_SIMULATOR_BUNDLES_PATH)/$(BUNDLE_NAME).bundle
	@sudo cp -vR $(THEOS_OBJ_DIR)/$(BUNDLE_NAME).bundle $(PL_SIMULATOR_BUNDLES_PATH)/
endif
