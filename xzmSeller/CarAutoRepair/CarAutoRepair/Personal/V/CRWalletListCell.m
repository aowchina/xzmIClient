//
//  CRWalletListCell.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/2.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRWalletListCell.h"
#import "CRTixianModel.h"

@implementation CRWalletListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CRTixianModel *)model {
    
    self.typeLabel.text = [model.type integerValue] == 1 ? @"提现到支付宝" :@"提现到微信";
    
    if (model.paytime.length > 7) {
        
        self.timeLabel.text = [[model.paytime substringWithRange:NSMakeRange(0, 5)] stringByReplacingOccurrencesOfString:@":" withString:@"/"];
        
    }
    
    self.moneyLabel.text = [@"¥ " stringByAppendingString:model.txmoney];
    
}

@end
