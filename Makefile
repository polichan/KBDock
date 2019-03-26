GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

ARCHS = arm64
SDKVERSION = 11.2
SYSROOT = $(THEOS)/sdks/iPhoneOS11.2.sdk

TWEAK_NAME = KBDock
# KBDock_LIBRARIES = sparkapplist
KBDock_FILES = KBDock.xm KBDockCollectionView.m KBDockCollectionViewCell.m

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += kbdocksettings
include $(THEOS_MAKE_PATH)/aggregate.mk
