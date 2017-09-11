//
//  CRGoodsManageCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/5.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRGoodsManageCell.h"
#import "GoodManageModel.h"

@interface CRGoodsManageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *firBtn;
@property (weak, nonatomic) IBOutlet UIButton *secBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirBtn;

@end

@implementation CRGoodsManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDataWithModel:(GoodManageModel *)model andType:(NSInteger)type {
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:kImage(@"CRPlaceholderImage")];
    
    self.nameLabel.text = model.name;
    
    self.cardetailLabel.text = model.car_name;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    self.dateLabel.text = model.addtime;
    
    if (type == 0) {

        [self.secBtn setTitle:@"下架" forState:UIControlStateNormal];
        
        self.thirBtn.hidden = YES;
        self.firBtn.hidden = YES;

        
    } else if (type == 1) {

        [self.secBtn setTitle:@"上架" forState:UIControlStateNormal];
        
        self.thirBtn.hidden = YES;
        self.firBtn.hidden = YES;
        
    } else if (type == 2) {

        [self.secBtn setTitle:@"审核中" forState:UIControlStateNormal];
        
        self.thirBtn.hidden = NO;
        self.firBtn.hidden = NO;

        
    } else if (type == 3) {
        [self.secBtn setTitle:@"审核不通过" forState:UIControlStateNormal];
        
        self.thirBtn.hidden = NO;
        self.firBtn.hidden = NO;
    }
    
}

- (IBAction)clickBtnAction:(UIButton *)sender {
    
    if (_clickEditBtnBlock) {
        
        _clickEditBtnBlock(sender.tag, self);
        
    }
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 1;
    
    [super setFrame:frame];

}

@end
