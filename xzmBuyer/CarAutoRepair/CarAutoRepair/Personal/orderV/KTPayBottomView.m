//
//  KTPayBottomView.m
//  KantoCooking
//
//  Created by minfo019 on 17/4/12.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "KTPayBottomView.h"

@implementation KTPayBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"KTPayBottomView" owner:nil options:nil].firstObject;
    }
    return self;
}

- (IBAction)cancelBtnAction:(id)sender {
    
    if (_cancelPayBlock) {
        _cancelPayBlock();
    }
}

- (IBAction)aliPayBtnAction:(UIButton *)sender {

    if (_aliPayActionBlock) {
        _aliPayActionBlock();
    }
}

- (IBAction)balanceBtnAction:(id)sender {
    
    if (_balanceActionVlock) {
        _balanceActionVlock();
    }
}

- (IBAction)weChatBtnAction:(UIButton *)sender {

    if (_weChatPayActionBlock) {
        _weChatPayActionBlock();
    }
}

@end
