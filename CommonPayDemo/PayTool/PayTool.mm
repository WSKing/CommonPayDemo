//
//  PayTool.m
//  JewelryStore
//
//  Created by wsk on 17/2/22.
//  Copyright © 2017年 com. All rights reserved.
//

#import "PayTool.h"
#import "WXApi.h"
#import "UPPaymentControl.h"

@interface PayTool ()
@property (nonatomic, strong) UPPaymentControl *payment;
@end

static PayTool *_tool;
@implementation PayTool

+(PayTool *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[PayTool alloc] init];
    });
    return _tool;
}
//预支付码微信
-(void)weChatPayWithTotalFee:(NSString *)totalFee andOrderNo:(NSString *)orderNo {
//    UserModel *user = [UserLocal user];
    [LYHttpTool requestDateWithUrlString:WX_PREPAY_URL
                                  params:@{
                                           @"Access_Token":@"123123",
                                           @"orderNo":orderNo,
                                           @"UserId":@"123213",
                                           @"chargeamount":totalFee,
                                           @"spbill_create_ip":[DeviceTool publicNetworkIp]
                                           }
                         showAllResponse:YES
                                 success:^(id responseObject) {
                                     NSString *Error = [responseObject valueForKey:@"Error"];
                                     NSInteger errcorCode = [Error integerValue];
                                     if (errcorCode == 0) {
                                         WXParamModel *model = [WXParamModel mj_objectWithKeyValues:[responseObject valueForKey:@"Result"]];
                                         [self dealWithWXPay:model];
                                     }
                                     
                                 } failure:^(NSString *errorMsg) {
                                     
                                 }];

}
//向微信发起支付
- (void)dealWithWXPay:(WXParamModel *)model {
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = model.partnerId;
    req.prepayId = model.prepayId;
    req.package = model.packageValue;
    req.nonceStr = model.nonceStr;
    req.timeStamp = model.timeStamp;
    req.sign = model.sign;
    [WXApi sendReq:req];
}



//支付宝
- (void)aliPayWithOrderNo:(NSString *)orderNo andTotalFee:(NSString *)totalFee andBody:(NSString *)body andSubject:(NSString *)subject {
    [LYHttpTool requestDateWithUrlString:ALI_PAY_PAYMENT
                                  params:@{
                                           @"Access_Token":@"123123",
                                           @"Body":body,
                                           @"Subject":subject,
                                           @"TotalAmount":totalFee,
                                           @"ProductCode":@"QUICK_MSECURITY_PAY",
                                           @"OutTradeNo":orderNo,
                                           @"TimeoutExpress":@"30m"
                                           }
                         showAllResponse:YES
                                 success:^(id responseObject) {
                                     NSString *order = [responseObject valueForKey:@"Result"];
                                     
                                     [[AlipaySDK defaultService] payOrder:order fromScheme:@"alisdkLicaishen" callback:^(NSDictionary *resultDic) {
                                         NSInteger resultCode = [resultDic[@"resultStatus"] integerValue];
                                         switch (resultCode) {
                                             case 9000:     //支付成功
                                                 NSLog(@"支付成功");
                                                 break;
                                             case 6001:     //支付取消
                                                 NSLog(@"支付取消");
                                                 break;
                                             default:        //支付失败
                                                 NSLog(@"支付失败");
                                                 break;
                                         }
                                     }];
                                 } failure:^(NSString *errorMsg) {
                                     
                                 }];

}

//银联
- (void)uppaymentWithOrderNo:(NSString *)orderNo andTotalFee:(NSString *)totalFee withViewCOntroller:(UIViewController *)viewController {
    NSInteger fee = [totalFee integerValue];
    NSInteger fenFee = fee * 10 *10;
    NSString *money = [NSString stringWithFormat:@"%ld",(long)fenFee];
    [LYHttpTool requestDateWithUrlString:UPPAYMENT_TN_URL
                                  params:@{@"Access_Token":@"123123",
                                           @"orderId":orderNo,
                                           @"txnAmt":money}
                         showAllResponse:YES
                                 success:^(id responseObject) {
                                     NSLog(@"%@",responseObject);
                                     NSString *error = [responseObject valueForKey:@"Error"];
                                     if ([error integerValue] == 0) {
                                         [self.payment startPay:[responseObject valueForKey:@"Result"]
                                                     fromScheme:@"licaishenUPPayment"
                                                           mode:@"00"
                                                 viewController:viewController];
                                     }
                                 } failure:^(NSString *errorMsg) {
                                     NSLog(@"%@",errorMsg);
                                 }];

}


- (UPPaymentControl *)payment {
    if (!_payment) {
        _payment = [UPPaymentControl defaultControl];
    }
    return _payment;
}
@end
