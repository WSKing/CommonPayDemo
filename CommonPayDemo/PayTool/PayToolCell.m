//
//  PayToolCell.m
//  JewelryStore
//
//  Created by wsk on 17/3/7.
//  Copyright © 2017年 com. All rights reserved.
//

#import "PayToolCell.h"

@implementation PayToolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)selectAction:(UIButton *)sender {
    if (self.selectedPayTool) {
        self.selectedPayTool(self.payType);
    }
}

- (void)setHasSelected:(BOOL)hasSelected {
    _hasSelected = hasSelected;
    self.selctedBtn.selected = hasSelected;
}

@end
