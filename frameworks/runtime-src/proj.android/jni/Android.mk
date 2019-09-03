
LOCAL_PATH := $(call my-dir)

# include $(CLEAR_VARS)
# LOCAL_MODULE := libyunceng
# LOCAL_SRC_FILES := prebuilt/libyunceng.so
# include $(PREBUILT_SHARED_LIBRARY)

# include $(CLEAR_VARS)
# LOCAL_MODULE := msc
# LOCAL_SRC_FILES := libmsc.so
# include $(PREBUILT_SHARED_LIBRARY)

# --- libweibosdkcore.so ---
include $(CLEAR_VARS)
LOCAL_MODULE := libweibosdkcore
LOCAL_SRC_FILES := prebuilt/$(TARGET_ARCH_ABI)/libweibosdkcore.so
include $(PREBUILT_SHARED_LIBRARY)
# --- end — 

# --- libYvImSdk.so ---
include $(CLEAR_VARS)
LOCAL_MODULE := libYvImSdk
LOCAL_SRC_FILES := prebuilt/libYvImSdk.so
include $(PREBUILT_SHARED_LIBRARY)
# --- end —

# --- 引用 libBugly.so ---
include $(CLEAR_VARS)

LOCAL_MODULE := bugly_native_prebuilt
# 可在Application.mk添加APP_ABI := armeabi armeabi-v7a 指定集成对应架构的.so文件
LOCAL_SRC_FILES := prebuilt/$(TARGET_ARCH_ABI)/libBugly.so

include $(PREBUILT_SHARED_LIBRARY)
# --- end ---


include $(CLEAR_VARS)
LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_SRC_FILES := \
../../Classes/AppDelegate.cpp \
../../Classes/MD5.cpp \
../../Classes/UtilityExtension.cpp \
../../Classes/lua_UtilityExtension_auto.cpp \
../../Classes/ide-support/SimpleConfigParser.cpp \
../../Classes/ide-support/RuntimeLuaImpl.cpp \
../../Classes/ide-support/lua_debugger.c \
hellolua/main.cpp \
../../Classes/Crypto/FilesSystem.cpp \
../../Classes/Crypto/PLTCRC.cpp \
../../Classes/Crypto/PLTCryptoAes.cpp \
../../Classes/Crypto/PLTFileEx.cpp \
../../Classes/Crypto/crypto/AES/aes_core.c \
../../Classes/Crypto/crypto/CRC/lib_crc.cpp \
../../Classes/Crypto/crypto/MD5/MD5Checksum.cpp\

#cjson
LOCAL_SRC_FILES += ../../../cocos2d-x/external/lua/cjson/fpconv.c \
../../../cocos2d-x/external/lua/cjson/lua_cjson.c \
../../../cocos2d-x/external/lua/cjson/strbuf.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../Classes

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += cocos2d_simulator_static

# 引用 bugly/Android.mk 定义的Module
LOCAL_STATIC_LIBRARIES += bugly_crashreport_cocos_static
# 引用 bugly/lua/Android.mk 定义的Module
LOCAL_STATIC_LIBRARIES += bugly_agent_cocos_static_lua



# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,tools/simulator/libsimulator/proj.android)


# 导入 bugly 静态库目录
$(call import-module,external/bugly)
$(call import-module,external/bugly/lua)


# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
