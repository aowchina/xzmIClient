//
//  CollectionViewHeaderView.m
//  Linkage
//
//  Created by 龚洪 on 2017/2/15.
//  Copyright © 2017年 赛联(武汉). All rights reserved.

#import "CollectionViewHeaderView.h"

@implementation CollectionViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self buildView];
    }
    return self;
}

- (void)buildView {
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];

    self.title = [[UILabel alloc] init];
    self.title.font = [UIFont systemFontOfSize:14];
    self.title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.offset(30);
        make.height.offset(20);
    }];
    
    /** 线 */
    UIView *lineView = [UIView new];
    lineView.backgroundColor = kColor(166, 166, 166);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title.mas_centerY);
        make.left.offset(10);
        make.right.equalTo(self.title.mas_left).offset(-10);
        make.height.offset(1);
    }];
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = kColor(166, 166, 166);
    [self addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title.mas_centerY);
        make.width.equalTo(lineView.mas_width);
        make.left.equalTo(self.title.mas_right).offset(10);
        make.height.offset(1);
    }];
    
}

@end
