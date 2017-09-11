//
//  CRHelpCenterCell.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/12.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRHelpCenterCell.h"
#import "CRHelpModel.h"

@implementation CRHelpCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CRHelpModel *)model
{
    _model = model;
    
    _titleLabel.text = _model.name;
}

@end
