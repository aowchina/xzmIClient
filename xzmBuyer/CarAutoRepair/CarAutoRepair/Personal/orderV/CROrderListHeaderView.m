//
//  CROrderListHeaderView.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/5/31.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CROrderListHeaderView.h"

@implementation CROrderListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.frame = frame;
        
        self = [[NSBundle mainBundle] loadNibNamed:@"CROrderListHeaderView" owner:nil options:nil].firstObject;
    }
    
    return self;
}

- (void)reloadCellType:(NSInteger)type
{
    switch (type)
    {
        case 0:
            _stateLabel.text = @"有状态";
            break;
        case 1:
            _stateLabel.text = @"";
            break;
        case 2:
            _stateLabel.text = @"";
            break;
        case 3:
            _stateLabel.text = @"";
            break;
        case 4:
            _stateLabel.text = @"";
            break;
            
        default:
            break;
    }
}
@end
