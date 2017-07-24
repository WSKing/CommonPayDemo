//
//  Common.h
//  WangShankun
//
//  Created by wsk on 17/4/8.
//  Copyright © 2017年 wsk. All rights reserved.
//

#ifndef Common_h
#define Common_h


#define KUmengAPPKey @"XXXXXXXXXXXXXX"
#define KWeChatAPPKey @"XXXXXXXXXXXXXX" //(微信)
#define KWeChatAPPSecret @"XXXXXXXXXXXXXX" //(微信)

#define KQQAPPKey @"XXXXXXXXXXXXXX" //(QQ)
#define KQQAPPSecret @"XXXXXXXXXXXXXX" //(QQ)
#define KSinaAPPKey @"XXXXXXXXXXXXXX" //(新浪)
#define KSinaAPPSecret @"XXXXXXXXXXXXXX" //(新浪)
#define ALIPID @"XXXXXXXXXXXXXX" //(支付宝PID)


#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
#define STATUS_BAR_HIGHT    (20)
#define NAVI_BAR_HIGHT      (44)
#define TAB_HIGHT           (49)
#define NAVI_HIGHT          (STATUS_BAR_HIGHT + NAVI_BAR_HIGHT)
#define SCALEW(value)       ((int)((SCREEN_WIDTH * (value) / 375)))
#define FB_FIX_SIZE_HEIGHT(H) (((H)/667.0) * SCREEN_HEIGHT)

#define IS_IPHONE_4         ( fabs((double)[[UIScreen mainScreen] bounds].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_5         ( fabs((double)[[UIScreen mainScreen] bounds].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6         ( fabs((double)[[UIScreen mainScreen] bounds].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6P        ( fabs((double)[[UIScreen mainScreen] bounds].size.height - ( double )736 ) < DBL_EPSILON )
#define IS_IPHONE           ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPAD             ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_IOS7             ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8             ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IS_IOS9             ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)


#define APP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define APP_SHORTVERSION    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUNDLENAME      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
#define APP_BUNDLEID        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

/*
 根据你自己的后台
 */
//支付
#define WX_PREPAY_URL           @"Weixin/askprepayid.aspx" //微信_预支付信息
#define ALI_PAY_PAYMENT         @"Alipay/Payment.aspx" //支付宝获取订单信息
#define UPPAYMENT_TN_URL        @"Unionpay/UnionpayTn.aspx"//银联流水号(tn)

//添加字典时数据安全
#define SafeDicObj(obj) ((obj) ? (obj) : @"")


#define FONT(A)             [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]


#define TabbarClickOldIndex  @"TabbarClickOldIndex"

#endif /* Common_h */
