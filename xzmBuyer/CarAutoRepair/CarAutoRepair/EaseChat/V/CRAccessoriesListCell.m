//
//  CRAccessoriesListCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/3.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAccessoriesListCell.h"
#import "CRFriendListModel.h"

@interface CRAccessoriesListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *skillLabel;

@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;

@property (weak, nonatomic) IBOutlet UILabel *zhuyingLabel;


@end

@implementation CRAccessoriesListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CRFriendListModel *)model {
    
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:kImage(@"qixiu_touxiang")];
    
    self.skillLabel.text = model.skill;
    
    if ([model.type isEqualToString:@"friend"]) {
        
        self.nameLabel.text = model.name;
        
        self.zhuyingLabel.hidden = YES;
        self.skillLabel.hidden = YES;
    } else {
        
        self.zhuyingLabel.hidden = NO;
        self.skillLabel.hidden = NO;
        self.nameLabel.text = model.name;
    }
    
    if ([model.type isEqualToString:@"accessory"]) {
        
        self.addFriendBtn.hidden = [model.is_friend integerValue] == 1 ? YES : NO;
        
    } else {
        
        self.addFriendBtn.hidden = YES;
    }

}

- (IBAction)addFriendBtnAction:(UIButton *)sender {
    

    if (_addFriendBlock) {
        
        _addFriendBlock(self);
    }
    
}


@end
