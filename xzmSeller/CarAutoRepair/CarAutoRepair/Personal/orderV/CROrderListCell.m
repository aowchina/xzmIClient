//
//  CROrderListCell.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/14.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CROrderListCell.h"
#import "CROrderListModel.h"

@implementation CROrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadCell:(CROrderListModel *)model Type:(NSInteger )type and:(NSInteger)orderType
{
    
    if (orderType == 0) {
        
        _orderNumber.text = [NSString stringWithFormat:@"订单编号：%@",model.orderid];
        
        [_goodsImgV sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:kImage(@"CRPlaceholderImage")];
        
        _goodsName.text = model.name;
        
        _goodsPrice.text = [NSString stringWithFormat:@"¥%@",model.money];
        
        _goodsNum.text = [NSString stringWithFormat:@"x%@",model.amount];
        
    } else {
        
        _orderNumber.text = [NSString stringWithFormat:@"订单编号：%@",model.qgorderid];
        
        [_goodsImgV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:kImage(@"CRPlaceholderImage")];
        
        _goodsName.text = model.jname;
        
        NSArray *array = @[@"原厂",@"拆车",@"品牌",@"其他"];
        
        NSArray *typeArr = [model.type componentsSeparatedByString:@","];
        
        NSMutableString *typeStr = [[NSMutableString alloc] init];
        
        for (NSString *str in typeArr) {
            
            if ([str integerValue] < array.count) {
                [typeStr appendFormat:@"%@ ",array[[str integerValue]]];
            }
        }
        
        _goodsPrice.text = typeStr;
        
        _goodsNum.text = [NSString stringWithFormat:@"共:¥%@",model.total_money];
    }

    switch (type)
    {
        case 0:
            
            _orderTime.text = [NSString stringWithFormat:@"下单时间：%@",model.addtime];
            break;
        case 1:
            
            _orderTime.text = [NSString stringWithFormat:@"下单时间：%@",model.addtime];
            break;
        case 2:
            
            _orderTime.text = [NSString stringWithFormat:@"发货时间：%@",model.addtime];
            break;
        case 3:
            
            _orderTime.text = [NSString stringWithFormat:@"收货时间：%@",model.addtime];
            break;
        case 4:
            
            _orderTime.text = [NSString stringWithFormat:@"收货时间：%@",model.addtime];
            break;
            
        default:
            break;
    }
}

@end
