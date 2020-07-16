ARCHS = arm64 arm64e
TARGET = iphone:clang::13.5

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nita
$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = Cephei
$(TWEAK_NAME)_LIBRARIES = pddokdo

include $(THEOS_MAKE_PATH)/tweak.mk
