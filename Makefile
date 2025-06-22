INSTALL_TARGET_PROCESSES = Amazon
THEOS_PACKAGE_SCHEME = rootless
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
THEOS_PACKAGE_ARCH = iphoneos-arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RemoveAmazonAI
RemoveAmazonAI_FILES = Tweak.x
RemoveAmazonAI_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk