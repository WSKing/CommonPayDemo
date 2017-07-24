//
//  DeviceTool.m
//  JewelryStore
//
//  Created by wsk on 17/3/8.
//  Copyright © 2017年 com. All rights reserved.
//

#import "DeviceTool.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
@implementation DeviceTool

+(NSString *)publicNetworkIp {
    NSString *publicNetworkIp = @"192.168.1.101";
    NSStringEncoding enc;
    NSString *returnStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"] usedEncoding:&enc error:nil];
    returnStr = [returnStr componentsSeparatedByString:@"="][1];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@";" withString:@""];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[returnStr dataUsingEncoding:enc] options:0 error:nil];
    if ([dic isKindOfClass:[NSDictionary class]] && dic[@"cip"]) {
        publicNetworkIp = dic[@"cip"];
    }
    return publicNetworkIp;
}

+ (void)openSystemSetting {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end
