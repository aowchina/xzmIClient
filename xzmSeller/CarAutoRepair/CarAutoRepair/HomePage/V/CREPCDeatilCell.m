//
//  CREPCDeatilCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CREPCDeatilCell.h"
#import "CREPCDetailModel.h"

@implementation CREPCDeatilCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.width -= 1;
    
    [super setFrame:frame];
}

- (void)setModel:(CREPCDetailModel *)model
{
    _model = model;
    
    _locationLabel.text = _model.position;
    
    _nameLabel.text = _model.name;
    
    _oemLabel.text = _model.oem;
}

@end
