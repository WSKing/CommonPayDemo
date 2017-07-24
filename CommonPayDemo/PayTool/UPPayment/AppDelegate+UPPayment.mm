//
//  AppDelegate+UPPayment.m
//  JewelryStore
//
//  Created by wsk on 17/3/28.
//  Copyright © 2017年 com. All rights reserved.
//

#import "AppDelegate+UPPayment.h"
#import "UPPaymentControl.h"
@implementation AppDelegate (UPPayment)
+ (NSString *)setupUPPaymentResultWithUrl:(NSURL *)url {
    UPPaymentControl *control = [UPPaymentControl defaultControl];
   __block NSString *resultCode;
    [control handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        resultCode = code;
    }];
    return resultCode;
}


@end
