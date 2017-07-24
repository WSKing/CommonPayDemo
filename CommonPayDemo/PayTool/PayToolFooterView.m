//
//  PayToolFooterView.m
//  JewelryStore
//
//  Created by wsk on 17/3/7.
//  Copyright © 2017年 com. All rights reserved.
//

#import "PayToolFooterView.h"

@implementation PayToolFooterView

+(instancetype)instanceView {
    PayToolFooterView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PayToolFooterView class]) owner:nil options:nil].lastObject;
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.payButton.layer.cornerRadius = 3;
    self.payButton.clipsToBounds = YES;
}

@end
