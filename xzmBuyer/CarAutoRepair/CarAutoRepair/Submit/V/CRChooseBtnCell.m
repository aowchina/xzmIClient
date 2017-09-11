//
//  CRChooseBtnCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/26.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRChooseBtnCell.h"

@implementation CRChooseBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)imageBtnAction:(UIButton *)sender {
    
    if (_clickCameraBlock) {
        _clickCameraBlock();
    }
    
}

@end
