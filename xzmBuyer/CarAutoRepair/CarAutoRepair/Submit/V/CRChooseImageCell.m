//
//  CRChooseImageCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/26.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRChooseImageCell.h"

@implementation CRChooseImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteBtnAction:(UIButton *)sender {
    
    if (_clickDeleteBtnBlock) {
        _clickDeleteBtnBlock(self);
    }
}

@end
