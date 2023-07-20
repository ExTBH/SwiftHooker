ARCHS = arm64 arm64e

TARGET := iphone:clang:latest:8.0
include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = SwiftHooker





SwiftHooker_FILES = $(shell find Sources/SwiftHooker -name '*.swift') Sources/SwiftHookerC/SwiftHooker.m
SwiftHooker_PUBLIC_HEADERS = SwiftHooker.h
SwiftHooker_INSTALL_PATH = /Library/Frameworks
SwiftHooker_CFLAGS = -fobjc-arc

ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
SwiftHooker_LDFLAGS += -install_name @rpath/$(FRAMEWORK_NAME).framework/$(FRAMEWORK_NAME)
endif

include $(THEOS_MAKE_PATH)/framework.mk

before-stage::
	$(eval SOURCE_FILE := $(THEOS_OBJ_DIR)/arm64/generated/$(FRAMEWORK_NAME)-Swift.h)
	$(eval DESTINATION_DIR := $(THEOS_OBJ_DIR)/$(FRAMEWORK_NAME).framework/Headers)
	cp $(SOURCE_FILE) $(DESTINATION_DIR)
	xcrun tapi stubify --filetype=tbd-v4 $(THEOS_OBJ_DIR)/$(FRAMEWORK_NAME).framework

include $(THEOS_MAKE_PATH)/aggregate.mk
