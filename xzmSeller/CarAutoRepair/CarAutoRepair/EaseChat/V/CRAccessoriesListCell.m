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



@end

@implementation CRAccessoriesListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CRFriendListModel *)model {
    
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:kImage(@"qixiu_touxiang1")];
    
    self.nameLabel.text = model.name;
    
    self.skillLabel.hidden = YES;
    
    self.addFriendBtn.hidden = [model.type isEqualToString:@"accessory"] ? NO : YES;
    
}

- (IBAction)addFriendBtnAction:(UIButton *)sender {
    

    if (_addFriendBlock) {
        
        _addFriendBlock(self);
    }
    
}


@end
