//
//  CRMycollectionCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRMycollectionCell.h"
#import "CRMyCollecModel.h"

@implementation CRMycollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
}
- (IBAction)cancelCollecBtnClick:(id)sender
{
    if (self.cancelBlock)
    {
        self.cancelBlock();
    }
}

- (void)setModel:(CRMyCollecModel *)model
{
    _model = model;
    
    [self.goodImgView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:kImage(@"CRPlaceholderImage")];
    
    self.nameLabel.text = _model.name;
    
    self.goodPeice.text = [NSString stringWithFormat:@"¥%@",_model.price];
    
    self.brandLabel.text = _model.bname;
    
    self.modelLabel.text = [NSString stringWithFormat:@"%@ %@",_model.sname,_model.cname];
}
@end
