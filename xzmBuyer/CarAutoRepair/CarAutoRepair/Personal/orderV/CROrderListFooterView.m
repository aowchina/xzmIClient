//
//  CROrderListFooterView.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/5/31.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CROrderListFooterView.h"

@implementation CROrderListFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.frame = frame;
        
        self = [[NSBundle mainBundle] loadNibNamed:@"CROrderListFooterView" owner:nil options:nil].firstObject;
    }
    return self;
}

- (IBAction)btnClick:(id)sender
{
    if (self.btnBlock)
    {
        self.btnBlock();
    }
}

- (void)reloadCellType:(NSInteger)type
{
    switch (type)
    {
        case 0:
            [_footerBtn setTitle:@"全部状态" forState:UIControlStateNormal];
            break;
        case 1:
            [_footerBtn setTitle:@"待付款" forState:UIControlStateNormal];
            break;
        case 2:
            [_footerBtn setTitle:@"待发货" forState:UIControlStateNormal];
            break;
        case 3:
            [_footerBtn setTitle:@"待收货" forState:UIControlStateNormal];
            break;
        case 4:
            [_footerBtn setTitle:@"待评价" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

@end
