//
//  PayToolCell.h
//  JewelryStore
//
//  Created by wsk on 17/3/7.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayToolCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *toolTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLael;
@property (weak, nonatomic) IBOutlet UIButton *selctedBtn;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, copy) void(^selectedPayTool)(NSString *type);
@property (nonatomic, assign) BOOL hasSelected;
@end
