//
//  DeviceTool.h
//  JewelryStore
//
//  Created by wsk on 17/3/8.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceTool : NSObject
//获取公网IP
+ (NSString *)publicNetworkIp;

//打开系统设置
+ (void)openSystemSetting;
@end
