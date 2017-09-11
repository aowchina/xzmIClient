//
//  CRSearchTableViewCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRSearchTableViewCell.h"
#import "CROEMSearchModel.h"

@implementation CRSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

- (void)setModel:(CROEMSearchModel *)model
{
    _model = model;
    
    _nameLabel.text = _model.name;
    
    _brandLabel.text = _model.bname;
    
    _oemLabel.text = _model.oem;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.price];
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:kImage(@"CRPlaceholderImage")];
}

@end
