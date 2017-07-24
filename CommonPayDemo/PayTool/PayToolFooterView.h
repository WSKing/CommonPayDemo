//
//  PayToolFooterView.h
//  JewelryStore
//
//  Created by wsk on 17/3/7.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayToolFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
+ (instancetype)instanceView;
@end
