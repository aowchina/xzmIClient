//
//  KTProductCell.m
//  KantoCooking
//
//  Created by minfo019 on 17/4/10.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "KTProductCell.h"
#import "CREPCChartLeftModel.h"

@interface KTProductCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgView;/** 背景图 */

@end

@implementation KTProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    if (selected) {
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textColor = [UIColor blackColor];
    } else {
        self.bgView.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = ColorForRGB(0x828282);
    }
}

- (void)setModel:(CREPCChartLeftModel *)model
{
    _model = model;
    
    _titleLabel.text = _model.tname;

}

@end
