//
//  UIColor+Util.h
//  AT
//
//  Created by Summer on 8/3/14.
//  Copyright (c) 2014 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)
/**
 *  用16进制获取颜色
 *
 *  @param stringToConvert 要转成颜色的十六进制字符,以#开始
 *
 *  @return UIColor本类
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
