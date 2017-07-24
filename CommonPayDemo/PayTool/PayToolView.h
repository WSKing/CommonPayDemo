//
//  PayToolView.h
//  JewelryStore
//
//  Created by wsk on 17/3/7.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PayToolView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *totalFee;
@property (nonatomic, strong) NSString *orderNo;
+(instancetype)instanceView;
@end
