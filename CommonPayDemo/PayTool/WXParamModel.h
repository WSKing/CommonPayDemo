//
//  WXParamModel.h
//  JewelryStore
//
//  Created by wsk on 17/3/7.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXParamModel : NSObject
/*
 "partnerId":"1400312402",
 "sign":"0B3F4885445470267A1FC4E74C001519","
 packageValue":"Sign=WXPay",
 "attach":"10580|10",
 "nonceStr":"iSpBVUlmmcxd6Oax",
 "timeStamp":"1488854892",
 "AppId":"wx092ff84066912530",
 "prepayId":"wx2017030710481006a3a5413b0073269468"
 */
@property (nonatomic, copy) NSString *partnerId; //商户号
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *packageValue;
@property (nonatomic, copy) NSString *attach;
@property (nonatomic, copy) NSString *nonceStr;
@property (nonatomic, assign) UInt32 timeStamp;
@property (nonatomic, copy) NSString *prepayId; //预支付码
@end
