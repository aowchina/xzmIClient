//
//  CRKeFuTableViewCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/7/12.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRKeFuTableViewCell.h"
#import "CRkefuModel.h"

@interface CRKeFuTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation CRKeFuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    
}

- (void)setModel:(CRkefuModel *)model {
    
    self.nameLable.text = model.name;
    
    self.phoneLabel.text = model.tel;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:kImage(@"qixiu_touxiang1")];

}


- (IBAction)chat_btnAction:(UIButton *)sender {
    
    
    if (_click_btnBlock) {
        
        _click_btnBlock(sender);
    }
    
}


@end
