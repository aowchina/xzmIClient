//
//  CRSubTypeTableViewCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/8.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRSubTypeTableViewCell.h"
#import "CRSubCarDetailModel.h"

@implementation CRSubTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadViewWithModel:(CRSubCarDetailModel *)model {
    
    self.selectBtn.hidden = YES;
    
   // self.selectBtn.selected = model.cellSelected;
    
    self.typeLabel.text = model.name;
}

@end
