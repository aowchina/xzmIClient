//
//  CarTypeTableViewCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CarTypeTableViewCell.h"

#import "CRCarDetailModel.h"

@interface CarTypeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *carTypeImageV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation CarTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
}

- (void)reloadViewWithModel:(CRCarDetailModel *)model andType:(NSInteger)type {
    
    self.selectBtn.hidden = !type;
    
    self.selectBtn.selected = model.cellSelected;
    
    [self.carTypeImageV sd_setImageWithURL:[NSURL URLWithString:model.cimage] placeholderImage:kImage(@"CRPlaceholderImage")];
    
    self.nameLabel.text = model.cname;
    
    self.priceLabel.text = [NSString stringWithFormat:@"参考价:¥%@",model.price];
}

@end
