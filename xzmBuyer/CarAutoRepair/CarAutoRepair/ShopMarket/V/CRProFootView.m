//
//  CRProFootView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRProFootView.h"
#import "CRProDetailModel.h"

@interface CRProFootView ()

@property (weak, nonatomic) IBOutlet UILabel *allProCount;
@property (weak, nonatomic) IBOutlet UILabel *neProCount;

@property (weak, nonatomic) IBOutlet UIImageView *nameImageV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CRProFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setModel:(CRProDetailModel *)model {

    [self.nameImageV sd_setImageWithURL:[NSURL URLWithString:model.sellerPicture] placeholderImage:kImage(@"qixiu_touxiang")];
    self.titleLabel.text = model.sellerName;
    self.allProCount.text = model.all_goods;
    self.neProCount.text = model.news;
    
}


- (IBAction)allProAction:(UIButton *)sender {
    
    if (_clickViewBtnBlock) {
        _clickViewBtnBlock(1000);
    }
}

- (IBAction)newProAction:(UIButton *)sender {
    
    if (_clickViewBtnBlock) {
        _clickViewBtnBlock(1001);
    }
}

@end
