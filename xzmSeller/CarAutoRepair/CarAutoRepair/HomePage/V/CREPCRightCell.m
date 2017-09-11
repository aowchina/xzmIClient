//
//  CREPCRightCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CREPCRightCell.h"
#import "CREPCChartRightModel.h"

@interface CREPCRightCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;


@end

@implementation CREPCRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.layer.cornerRadius = 10;
    self.backView.clipsToBounds = YES;
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = [ColorForRGB(0x828282) CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x = 10;
    
    frame.size.width -= 20;
    
    [super setFrame:frame];
}

- (void)setModel:(CREPCChartRightModel *)model
{
    _model = model;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.epcimg] placeholderImage:kImage(@"CRPlaceholderImage")];
}

@end
