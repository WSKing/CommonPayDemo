//
//  PayToolView.m
//  JewelryStore
//
//  Created by wsk on 17/3/7.
//  Copyright © 2017年 com. All rights reserved.
//

#import "PayToolView.h"
#import "PayToolCell.h"
#import "PayToolFooterView.h"
#import "WXApi.h"
#import "PayTool.h"
@interface PayToolView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) PayToolFooterView *footerView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *payType;
@end

@implementation PayToolView
static PayToolView *_toolView;
+(instancetype)instanceView {
    _toolView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PayToolView class]) owner:nil options:nil].lastObject;
    return _toolView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.footerView];
    [self bringSubviewToFront:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(@150);
    }];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.alpha = 1;
    [self.tableView  registerNib:[UINib nibWithNibName:NSStringFromClass([PayToolCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PayToolCell class])];
    self.userInteractionEnabled = YES;
    [self installReloadData];
    NSDictionary *dic = self.dataList.firstObject;
     self.payType = [dic valueForKey:@"type"];
    self.tableViewHeight.constant = 150 + 56 *self.dataList.count + 100 + FB_FIX_SIZE_HEIGHT(50);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayToolCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PayToolCell class]) forIndexPath:indexPath];
    NSDictionary *dic = self.dataList[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:[dic valueForKey:@"image"]];
    cell.toolTypeLabel.text = [dic valueForKey:@"title"];
    cell.detailLael.text = [dic valueForKey:@"detail"];
    cell.payType = [dic valueForKey:@"type"];
    __weak typeof(self)weakSelf = self;
    [cell setSelectedPayTool:^(NSString *type) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        weakSelf.index = indexPath.row;
        [strongSelf.tableView reloadData];
        self.payType = type;
    }];
    cell.hasSelected = self.index == indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.index = indexPath.row;
    [self.tableView reloadData];
    PayToolCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.payType = cell.payType;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"付款详情";
    titleLabel.textColor = [UIColor blackColor];
    [view addSubview:titleLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLabel.bottom + 10, SCREEN_WIDTH, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"付款方式";
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 90;
}

#pragma mark --actions
//点击空白处隐藏
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.y < SCREEN_HEIGHT - 400) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)setTotalFee:(NSString *)totalFee {
    _totalFee = totalFee;
    self.footerView.totalFeeLabel.text = [NSString stringWithFormat:@"%@元",totalFee];
}

- (void)payAction:(UIButton *)sender {
    NSLog(@"%@--付款",self.footerView.totalFeeLabel.text);
    CGFloat total = [self.totalFee floatValue];
    //微信支付
    if ([self.payType isEqualToString:@"WeChat"]) {
        
        if ( [WXApi isWXAppInstalled]) {
            if ([WXApi isWXAppSupportApi]) {
                PayTool *tool = [PayTool shareInstance];
                [tool weChatPayWithTotalFee:[NSString stringWithFormat:@"%.0f",total] andOrderNo:self.orderNo];
                
            }else{
                NSLog(@"不支持微信支付");
            }
        }else {
//            [MBProgressHUD showMessage:@"您的手机还没有安装微信,请选择其他支付方式" toView:self.superview hideAfterDelay:1];
        }
        
        //支付宝支付
    }else if ([self.payType isEqualToString:@"AliPay"]) {
        NSLog(@"支付-%@--%f",self.payType,total);
        PayTool *tool = [PayTool shareInstance];
        [tool aliPayWithOrderNo:self.orderNo andTotalFee:[NSString stringWithFormat:@"%.2f",total] andBody:@"李财神珠宝" andSubject:@"李财神珠宝"];
    }else {
        PayTool *tool = [PayTool shareInstance];
        [tool uppaymentWithOrderNo:self.orderNo andTotalFee:[NSString stringWithFormat:@"%.0f",total] withViewCOntroller:[self getViewController]];
    }

}

- (void)installReloadData {
    [self.dataList addObject:@{@"image":@"支付宝",@"title":@"支付宝支付",@"detail":@"支付宝安全支付",@"type":@"AliPay"}];
    if ([WXApi isWXAppInstalled]) {
        [self.dataList addObject:@{@"image":@"微信",@"title":@"微信支付",@"detail":@"微信安全支付",@"type":@"WeChat"}
         ];
    }
    [self.dataList addObject:@{@"image":@"uppayment",@"title":@"银联支付",@"detail":@"银联安全支付",@"type":@"UPPayment"}
     ];
    [self.tableView reloadData];
}
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UIView *)headerView {
    if(!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
        titleLabel.backgroundColor = [UIColor whiteColor];
        [titleLabel sizeToFit];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"付款详情";
        [_headerView addSubview:titleLabel];
    }
    return _headerView;
}

- (PayToolFooterView *)footerView {
    if (!_footerView) {
        _footerView = [PayToolFooterView instanceView];
        [_footerView.payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
@end
