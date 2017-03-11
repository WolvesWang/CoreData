//
//  WBDeviceProtocol.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/2.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WBDeviceRequestBlock)(NSDictionary *, NSError *);
typedef void (^WBDeviceSendSuccessBlock)(NSError *);
typedef void (^WBDeviceSendSuccessDictionaryBlock)(NSDictionary *);
typedef void (^WBDeviceSendFailureBlock)(NSError *);

typedef NS_ENUM(NSInteger, FLYChannelConnectionStatus) {
    FLYChannelConnectionStatusUnknown = -1,
    FLYChannelConnectionStatusDisconnected = 0,
    FLYChannelConnectionStatusConnecting,
    FLYChannelConnectionStatusConnected,
    FLYChannelConnectionStatusDiscovered
};

@protocol WBDeviceProtocol <NSObject>
@required
// All objects have identifiers
@property (atomic, readonly, copy) NSString *identifier; // UUID in string form

- (void)requestInfo;// Get 请求
- (id)sendRecordingCommand:(BOOL)recording
                   options:(NSDictionary *)recordOptions
                   success:(WBDeviceSendSuccessBlock)success
                   failure:(WBDeviceSendFailureBlock)failure;// POST HEAD
#pragma mark - Camera Collection
#pragma mark - Config

- (id)getCurrentCameraConfigUsingBlock:(WBDeviceSendSuccessBlock)completed;

- (id)sendCameraConfig:(NSDictionary *)config success:(WBDeviceSendSuccessBlock)success failure:(WBDeviceSendFailureBlock)failure;

#pragma mark - GPS
- (id)requestGpsStatus:(WBDeviceSendSuccessBlock)completed;

- (void)sendGpsEnableCommand:(BOOL)on success:(WBDeviceSendSuccessBlock)success failure:(WBDeviceSendFailureBlock)failure;

@end


@protocol WBDeviceBTLEProtocol <WBDeviceProtocol>

@required

- (id)sendNameChangeCommand:(NSString *)name
                    success:(WBDeviceSendSuccessBlock)success
                    failure:(WBDeviceSendFailureBlock)failure;

- (id)sendPasswordChangeCommand:(NSString *)password
                        success:(WBDeviceSendSuccessBlock)success
                        failure:(WBDeviceSendFailureBlock)failure;

- (void)sendPowerCommand:(BOOL)powerOn
                 success:(WBDeviceSendSuccessBlock)success
                 failure:(WBDeviceSendFailureBlock)failure;


@end

@protocol WBDeviceHTTPProtocol <WBDeviceProtocol>

@required

- (id)changeTuningParameters:(NSDictionary<NSNumber*,NSNumber*>*) typeAndValue completionBlock:(WBDeviceRequestBlock)completed;

@end

@protocol WBDeviceHTTPProtocolWithProperties <WBDeviceHTTPProtocol>

@required
/*
// Property to the device conjoining the BTLE and HTTP devices.
@property (atomic, readwrite, weak) FLYDevice *device;
*/
// Connection status for the HTTP device.
@property (atomic, assign) FLYChannelConnectionStatus connectionStatus;

@end

