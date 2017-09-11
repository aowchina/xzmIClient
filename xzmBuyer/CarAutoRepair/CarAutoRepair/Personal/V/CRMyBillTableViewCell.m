//
//  CRMyBillTableViewCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRMyBillTableViewCell.h"
#import "CRBillModel.h"

@implementation CRMyBillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CRBillModel *)model
{
    _model = model;
    
    switch ([_model.type integerValue])
    {
        case 1:
            
            _typeLabel.text = @"订单退款";
            _moneyLabel.textColor = [UIColor redColor];
            _moneyLabel.text = [NSString stringWithFormat:@"+%@",_model.money];
            break;
        case 2:
            
            _typeLabel.text = @"订单付款";
            _moneyLabel.textColor = [UIColor blackColor];
            _moneyLabel.text = [NSString stringWithFormat:@"-%@",_model.money];
            break;
        case 3:
            
            _typeLabel.text = @"提现";
            _moneyLabel.textColor = [UIColor redColor];
            _moneyLabel.text = [NSString stringWithFormat:@"+%@",_model.money];
            break;
            
        default:
            break;
    }
    
    _timeLabel.text = _model.addtime;
    
    
    
    
    
}

@end
