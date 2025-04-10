#import "AliyunFacePlugin.h"
#import <AliyunFaceAuthFacade/AliyunFaceAuthFacade.h>

@implementation AliyunFacePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"aliyun_face_plugin"
            binaryMessenger:[registrar messenger]];
  AliyunFacePlugin* instance = [[AliyunFacePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    static Boolean bInit = false;

    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        NSLog(@"enter getPlatformVersion");
        result([@"" stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
        return;
    }
    
    if ([@"init" isEqualToString:call.method]) {
        NSLog(@"enter init");
        
        if (!bInit) {
            bInit = true;
            [AliyunFaceAuthFacade initSDK];
        }

        return;
    }
    
    if ([@"getMetaInfos" isEqualToString:call.method]) {
        NSLog(@"enter getMetaInfos");
        
        if (!bInit) {
            bInit = true;
            [AliyunFaceAuthFacade initSDK];
        }

        NSDictionary *metaInfo = [AliyunFaceAuthFacade getMetaInfo];
        NSString *info = [self convertToJsonData: metaInfo];
        result([@"" stringByAppendingString:info]);
        return;
    }
    
    if ([@"verify" isEqualToString:call.method]) {
        NSLog(@"enter verify");

        if (!bInit) {
            bInit = true;
            [AliyunFaceAuthFacade initSDK];
        }

        id arguments = call.arguments;
        NSString *certifyId = [arguments objectForKey:@"certifyId"];
        if (certifyId == nil || [certifyId length] == 0) {
            NSLog(@"certifyId is nil.");
            return;
        }
        NSLog(@"certifyId: %@.", certifyId);
        
        NSMutableDictionary *extParams = [NSMutableDictionary new];
        UIViewController *vc = [self viewControllerWithWindow:nil];
        [extParams setValue:vc forKey:@"currentCtr"];   // 必须要的参数
        
         [AliyunFaceAuthFacade verifyWith:certifyId
                                            extParams:extParams
                                            onCompletion:^(ZIMResponse *response) {
             result([NSString stringWithFormat:@"%lu,%@", response.code, response.reason]);
         }];
        
        return;
    }
    
    if ([@"setCustomUI" isEqualToString:call.method]) {
        NSString *jsonString = call.arguments;

        [AliyunFaceAuthFacade setCustomUI:jsonString type:@"json" completion:^(BOOL success, NSError * _Nonnull error) {
            NSLog(@"%@",error.localizedDescription);
        }];
        return;
    }
    
    result(FlutterMethodNotImplemented);
}

#pragma mark - 辅助方法

- (NSString *)convertToJsonData:(NSDictionary *) dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                        options:NSJSONWritingSortedKeys
                                        error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"Error: %@", error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (UIViewController *) viewControllerWithWindow:(UIWindow *)window {
    UIWindow *windowToUse = window;
    if(windowToUse == nil) {
        for (UIWindow *windowF in [UIApplication sharedApplication].windows) {
            if (windowF.isKeyWindow) {
                windowToUse = windowF;
                break;
            }
        }
    }
    UIViewController *topViewController = windowToUse.rootViewController;
    while (topViewController.presentingViewController) {
        topViewController = topViewController.presentingViewController;
    }
    return  topViewController;
}

@end
