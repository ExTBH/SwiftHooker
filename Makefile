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
	$(ECHO_BEGIN)$(PRINT_FORMAT_YELLOW) "Copying Neccessary files for Functionality"$(ECHO_END)
	$(eval SOURCE_FILE := $(THEOS_OBJ_DIR)/arm64/generated/$(FRAMEWORK_NAME)-Swift.h)
	$(eval FRAMEWORK_DIR := $(THEOS_OBJ_DIR)/$(FRAMEWORK_NAME).framework)
	$(ECHO_NOTHING)cp $(SOURCE_FILE) $(FRAMEWORK_DIR)/Headers$(ECHO_END)
	$(ECHO_NOTHING)mkdir -p $(FRAMEWORK_DIR)/Modules/$(FRAMEWORK_NAME).swiftmodule/Project$(ECHO_END)
	$(ECHO_NOTHING)cp module.modulemap $(FRAMEWORK_DIR)/Modules$(ECHO_END)
	$(ECHO_NOTHING)cp $(THEOS_OBJ_DIR)/arm64/$(FRAMEWORK_NAME).swiftmodule $(FRAMEWORK_DIR)/Modules/$(FRAMEWORK_NAME).swiftmodule/arm64-apple-ios.swiftmodule$(ECHO_END)
	$(ECHO_NOTHING)cp $(THEOS_OBJ_DIR)/arm64/$(FRAMEWORK_NAME).abi.json $(FRAMEWORK_DIR)/Modules/$(FRAMEWORK_NAME).swiftmodule/arm64-apple-ios.abi.json$(ECHO_END)
	$(ECHO_NOTHING)cp $(THEOS_OBJ_DIR)/arm64/$(FRAMEWORK_NAME).swiftsourceinfo $(FRAMEWORK_DIR)/Modules/$(FRAMEWORK_NAME).swiftmodule/Project/arm64-apple-ios.swiftsourceinfo$(ECHO_END)
	$(ECHO_NOTHING)cp $(THEOS_OBJ_DIR)/arm64e/$(FRAMEWORK_NAME).swiftmodule $(FRAMEWORK_DIR)/Modules/$(FRAMEWORK_NAME).swiftmodule/arm64e-apple-ios.swiftmodule$(ECHO_END)
	$(ECHO_NOTHING)cp $(THEOS_OBJ_DIR)/arm64e/$(FRAMEWORK_NAME).abi.json $(FRAMEWORK_DIR)/Modules/$(FRAMEWORK_NAME).swiftmodule/arm64e-apple-ios.abi.json$(ECHO_END)
	$(ECHO_NOTHING)cp $(THEOS_OBJ_DIR)/arm64e/$(FRAMEWORK_NAME).swiftsourceinfo $(FRAMEWORK_DIR)/Modules/$(FRAMEWORK_NAME).swiftmodule/Project/arm64e-apple-ios.swiftsourceinfo$(ECHO_END)
	$(ECHO_NOTHING)$(SDKBINPATH)/tapi stubify --filetype=tbd-v4 $(THEOS_OBJ_DIR)/$(FRAMEWORK_NAME).framework$(ECHO_END)

include $(THEOS_MAKE_PATH)/aggregate.mk
