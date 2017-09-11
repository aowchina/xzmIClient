//
//  CRMakeSureHeaderView.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRMakeSureHeaderView.h"

@implementation CRMakeSureHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.frame = frame;
        
        self = [[NSBundle mainBundle] loadNibNamed:@"CRMakeSureHeaderView" owner:nil options:nil].firstObject;  
    }
    return self;
}



@end
