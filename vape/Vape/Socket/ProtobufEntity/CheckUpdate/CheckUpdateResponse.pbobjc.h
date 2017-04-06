// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: CheckUpdateResponse.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30001
#error This file was generated by a different version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class ErrorMessage;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - CheckUpdateResponseRoot

/// Exposes the extension registry for this file.
///
/// The base class provides:
/// @code
///   + (GPBExtensionRegistry *)extensionRegistry;
/// @endcode
/// which is a @c GPBExtensionRegistry that includes all the extensions defined by
/// this file and all files that it depends on.
@interface CheckUpdateResponseRoot : GPBRootObject
@end

#pragma mark - CheckUpdateResponseMessage

typedef GPB_ENUM(CheckUpdateResponseMessage_FieldNumber) {
  CheckUpdateResponseMessage_FieldNumber_ErrorMsg = 1,
  CheckUpdateResponseMessage_FieldNumber_Version = 2,
  CheckUpdateResponseMessage_FieldNumber_UpdateTime = 3,
  CheckUpdateResponseMessage_FieldNumber_UpdateLog = 4,
};

@interface CheckUpdateResponseMessage : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) ErrorMessage *errorMsg;
/// Test to see if @c errorMsg has been set.
@property(nonatomic, readwrite) BOOL hasErrorMsg;

@property(nonatomic, readwrite, copy, null_resettable) NSString *version;

@property(nonatomic, readwrite) int64_t updateTime;

@property(nonatomic, readwrite, copy, null_resettable) NSString *updateLog;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)