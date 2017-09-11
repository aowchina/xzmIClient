//
//  TracyTabBar.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/18.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TracyTabBar;

//设置代理
@protocol TracyTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(TracyTabBar *)tabBar;

@end

@interface TracyTabBar : UITabBar

@property (nonatomic, weak) id <TracyTabBarDelegate> tabDelegate;

@end
