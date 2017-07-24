//
//  PayTool.h
//  JewelryStore
//
//  Created by wsk on 17/2/22.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXParamModel.h"
#import <AlipaySDK/AlipaySDK.h>
@interface PayTool : NSObject
+(PayTool *)shareInstance;
//微信支付
- (void)weChatPayWithTotalFee:(NSString *)totalFee andOrderNo:(NSString *)orderNo;

//支付宝支付
- (void)aliPayWithOrderNo:(NSString *)orderNo andTotalFee:(NSString *)totalFee andBody:(NSString *)body andSubject:(NSString *)subject;

//银联

- (void)uppaymentWithOrderNo:(NSString *)orderNo andTotalFee:(NSString *)totalFee withViewCOntroller:(UIViewController *)viewController;
@end
