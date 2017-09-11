//
//  TracyTabBar.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/18.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyTabBar.h"

@interface TracyTabBar()

@property (nonatomic, weak) UIButton *plusBtn;

@end

@implementation TracyTabBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //3.添加一个按钮到tabbar中
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"fabu_icon"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"fabu_icon_light"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"fabu_icon"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"fabu_icon_light"] forState:UIControlStateHighlighted];
        
//        [plusBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"发布" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:ColorForRGB(0x828282)}] forState:UIControlStateNormal];
//        
//        plusBtn.titleEdgeInsets = UIEdgeInsetsMake(55, -57, 0, 0);
//        plusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -23, 0, 0);
        
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        
//        plusBtn.size = CGSizeMake(57, 80);
        
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:plusBtn];
        
        self.plusBtn = plusBtn;
    }
    return self;
}

//  加号按钮点击
- (void)plusClick {
    //通知代理
    if ([self.tabDelegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.tabDelegate tabBarDidClickPlusButton:self];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //1.设置加号按钮的位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.25;
    
    //2.设置其他tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = self.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            //设置宽度
            child.width = tabbarButtonW;
            //设置x
            child.x = tabbarButtonIndex * tabbarButtonW;
            //增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
}

@end
