//
//  UIColor+Util.m
//  AT
//
//  Created by Summer on 8/3/14.
//  Copyright (c) 2014 Summer. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6 && [cString length] != 8) {
        return [UIColor clearColor];
    }
    unsigned int r = 255.0f, g = 255.0f, b = 255.0f, a = 255.0f;
    [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r];
    [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g];
    [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b];
    if ([cString length] == 8) {
        [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(6, 2)]] scanHexInt:&a];
    }
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}
@end
