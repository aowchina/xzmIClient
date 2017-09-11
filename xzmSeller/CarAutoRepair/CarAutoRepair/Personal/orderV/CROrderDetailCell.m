//
//  CROrderDetailCell.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/5/31.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CROrderDetailCell.h"
#import "CROrderDetailModel.h"

@implementation CROrderDetailCell

- (void)awakeFromNib
{
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CROrderDetailModel *)model
{
    _model = model;
    
    if (model.orderType == 1) {
        
        [_smallImgView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:kImage(@"CRPlaceholderImage")];
        
        _titleLabel.text = _model.name;
        
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.money];
        
        _totalLabel.text = [NSString stringWithFormat:@"x%@",_model.amount];
        
        
        
    } else {
        
        [_smallImgView sd_setImageWithURL:[NSURL URLWithString:_model.picture] placeholderImage:kImage(@"CRPlaceholderImage")];
        
        NSArray *array = @[@"原厂",@"拆车",@"品牌",@"其他"];
        
        NSArray *typeArr = [_model.type componentsSeparatedByString:@","];
        
        NSMutableString *typeStr = [[NSMutableString alloc] init];
        
        for (NSString *str in typeArr) {
            
            [typeStr appendFormat:@"%@ ",array[[str integerValue]]];
        }
        
        _priceLabel.text = typeStr;
        
        _totalLabel.text = [NSString stringWithFormat:@"共:¥%@",_model.total_money];
        
        _titleLabel.text = _model.jname;
        
        
    }
    
    _sizeLabel.text = _model.bname;
    
    _modelLabel.text = [NSString stringWithFormat:@"%@%@",_model.sname,_model.cname];
}

@end
