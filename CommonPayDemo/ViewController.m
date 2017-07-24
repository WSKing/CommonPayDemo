//
//  ViewController.m
//  CommonPayDemo
//
//  Created by wsk on 17/7/24.
//  Copyright © 2017年 wsk. All rights reserved.
//

#import "ViewController.h"
#import "PayToolView.h"
@interface ViewController ()
@property (nonatomic, strong) PayToolView *payToolView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.center.y, SCREEN_WIDTH - 40, 40)];
    [payButton setImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [payButton setTitle:@"支付" forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
}

- (void)payAction:(UIButton *)sender {
    self.payToolView.alpha = 0;
    self.payToolView.totalFee = @"1234";
    self.payToolView.orderNo = @"123123123123123";
    [self.view addSubview:self.payToolView];
    [UIView animateWithDuration:0.5 animations:^{
        self.payToolView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.payToolView.alpha = 1;
    }];

}


- (PayToolView *)payToolView {
    if (!_payToolView) {
        _payToolView = [PayToolView instanceView];
    }
    return _payToolView;
}

@end
