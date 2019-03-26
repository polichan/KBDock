include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = KBDockSettings
KBDockSettings_FILES = KBDockRootListController.m
KBDockSettings_INSTALL_PATH = /Library/PreferenceBundles
KBDockSettings_FRAMEWORKS = UIKit
KBDockSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/KBDockSettings.plist$(ECHO_END)
