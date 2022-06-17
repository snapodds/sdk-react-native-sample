//
//  SnapscreenSDKModuleBridge.h
//  snapoddssample
//
//  Created by Martin Fitzka-Reichart on 17.06.22.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(SnapscreenSDKModule, NSObject)

RCT_EXTERN_METHOD(testNativeModule)

RCT_EXTERN_METHOD(setupWithClientId:(NSString *)clientId secret:(NSString *)secret)
RCT_EXTERN_METHOD(setupForTestEnvironmentWithClientId:(NSString *)clientId secret:(NSString *)secret)
RCT_EXTERN_METHOD(setCountry:(NSString *)country)
RCT_EXTERN_METHOD(setUsState:(NSString *)usState)
RCT_EXTERN_METHOD(presentSportMediaFlowWithConfiguration:(NSDictionary*) parameters)
RCT_EXTERN_METHOD(presentOperatorFlowWithConfiguration:(NSDictionary*) parameters callback: (RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(updateSnapUIConfiguration:(NSDictionary*) parameters)
RCT_EXTERN_METHOD(updateOddsUIConfiguration:(NSDictionary*) parameters)
RCT_EXTERN_METHOD(updateColorConfiguration:(NSDictionary*) parameters)

@end
