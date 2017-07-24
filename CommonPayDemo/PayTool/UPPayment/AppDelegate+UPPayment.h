//
//  AppDelegate+UPPayment.h
//  JewelryStore
//
//  Created by wsk on 17/3/28.
//  Copyright © 2017年 com. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (UPPayment)
+ (NSString *)setupUPPaymentResultWithUrl:(NSURL *)url;
@end
