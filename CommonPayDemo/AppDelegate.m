//
//  AppDelegate.m
//  CommonPayDemo
//
//  Created by wsk on 17/7/24.
//  Copyright © 2017年 wsk. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate+UPPayment.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[ViewController alloc] init];
    
    
    //支付
    [WXApi registerApp:KWeChatAPPKey withDescription:@"微信支付"];
    return YES;
}

#pragma mark --支付回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"%@",url);
    //处理支付宝支付结果
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:ALIPayResult object:resultDic];
        }];
    }else if ([url.host isEqualToString:@"pay"]) {
        // 处理微信的支付结果
        [WXApi handleOpenURL:url delegate:self];
    }else if ([url.host isEqualToString:@"uppayresult"]) {
        NSString *result = [AppDelegate setupUPPaymentResultWithUrl:url];
        NSLog(@"%@",result);
        [[NSNotificationCenter defaultCenter] postNotificationName:UPPaymentResult object:[NSDictionary dictionaryWithObject:result forKey:@"result"]];
    }
    return YES;
}


-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayReq class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:WeChatPaidSuccess object:[NSDictionary dictionaryWithObject:@(resp.errCode) forKey:@"result"]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
