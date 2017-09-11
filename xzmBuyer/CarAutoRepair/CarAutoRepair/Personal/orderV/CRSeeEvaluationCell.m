//
//  CRSeeEvaluationCell.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/21.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRSeeEvaluationCell.h"
#import "CRSeeEvaluationModel.h"

@implementation CRSeeEvaluationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CRSeeEvaluationModel *)model
{
    _model = model;
    
    _nameLabel.text = _model.name;
    
    _contentLabel.text = _model.content;
    
    _timeLabel.text = _model.addtime;
    
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:_model.picture] placeholderImage:kImage(@"qixiu_touxiang")];
}

- (CGFloat)height
{
   return CGRectGetMaxY(self.contentLabel.frame) + 20;
}

@end
