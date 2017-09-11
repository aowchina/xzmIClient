//
//  CREPCHeadView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CREPCHeadView.h"
#import "CRCarDetailModel.h"

@implementation CREPCHeadView

- (IBAction)changeCarTypeAction:(UIButton *)sender {
    
    if (_changeCarBlock) {
        
        _changeCarBlock();
    }
    
}


- (void)setModel:(CRCarDetailModel *)model {
    
    // 图片
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.cimage] placeholderImage:kImage(@"CRPlaceholderImage")];
    // 品牌车系
    self.firstLabel.text = [NSString stringWithFormat:@"%@ %@",model.bname,model.sname];
    // 车款
    self.secondLabel.text = [NSString stringWithFormat:@"%@",model.cname];
}

@end
