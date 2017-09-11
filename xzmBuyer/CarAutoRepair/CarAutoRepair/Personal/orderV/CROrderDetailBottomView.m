//
//  CROrderDetailBottomView.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/15.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CROrderDetailBottomView.h"

@implementation CROrderDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self.frame = frame;
    if (self = [super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"CROrderDetailBottomView" owner:nil options:nil].firstObject;
    }
    return self;
}

#pragma mark - 取消订单点击
- (IBAction)cancelBtnClick:(id)sender
{
    if (self.cancelBlock)
    {
        self.cancelBlock();
    }
}

#pragma mark - 立即支付点击
- (IBAction)payBtnClick:(id)sender
{
    if (self.payBlock)
    {
        self.payBlock();
    }
}

@end
