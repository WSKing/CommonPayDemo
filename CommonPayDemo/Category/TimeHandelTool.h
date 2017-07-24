//
//  TimeHandelTool.h
//  JewelryStore
//
//  Created by wsk on 17/4/5.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeHandelTool : NSObject
//获取当前时间的 时间戳
+(NSInteger)getNowTimestamp;

//将某个时间转化成 时间戳
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

//将某个时间戳转化成 时间
+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;
@end
