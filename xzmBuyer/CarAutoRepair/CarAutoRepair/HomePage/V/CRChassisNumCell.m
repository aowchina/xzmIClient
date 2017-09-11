//
//  CRChassisNumCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRChassisNumCell.h"
#import "CRChassisNumModel.h"

@implementation CRChassisNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(CRChassisNumModel *)model
{
    _model = model;
    
    _valueLabel.text = _model.value;
}

@end
