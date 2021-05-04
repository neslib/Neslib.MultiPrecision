LOCAL_PATH:= $(call my-dir)/..

include $(CLEAR_VARS)
 
LOCAL_CFLAGS += -Wno-absolute-value -DHP_ARM -DHP_ANDROID

ifdef MP_ACCURATE
LOCAL_CFLAGS += -DHP_ACCURATE
endif

LOCAL_MODULE    := mp-android

LOCAL_SRC_FILES := c_dd.cpp c_qd.cpp
 
include $(BUILD_STATIC_LIBRARY)
