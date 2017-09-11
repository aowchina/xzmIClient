//
//  CRProStoreCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/22.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRProStoreCell.h"
#import "CRStoreGoogsModel.h"

@implementation CRProStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CRStoreGoogsModel *)model
{
    _model = model;
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:kImage(@"CRPlaceholderImage")];
    
    _nameLabel.text = _model.name;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.price];
}

@end
