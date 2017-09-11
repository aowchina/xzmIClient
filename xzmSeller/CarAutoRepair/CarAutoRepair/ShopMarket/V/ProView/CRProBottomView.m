//
//  CRProBottomView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRProBottomView.h"

@implementation CRProBottomView

- (IBAction)kefuBtnAction:(UIButton *)sender {
    
    if (_clickBottomBlock) {
        _clickBottomBlock(1000);
    }
    
}

- (IBAction)dianpuBtnAction:(UIButton *)sender {
    
    if (_clickBottomBlock) {
        _clickBottomBlock(1001);
    }
}

- (IBAction)soucangBtnAction:(UIButton *)sender {
    
    if (_clickBottomBlock) {
        _clickBottomBlock(1002);
    }
}

- (IBAction)phoneBtnAction:(UIButton *)sender {
    
    if (_clickBottomBlock) {
        _clickBottomBlock(1003);
    }
}

- (IBAction)buynowBtnAction:(UIButton *)sender {
    
    if (_clickBottomBlock) {
        _clickBottomBlock(1004);
    }
}

@end
