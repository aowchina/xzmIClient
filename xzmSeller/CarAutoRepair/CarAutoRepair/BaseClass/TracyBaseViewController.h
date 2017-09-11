//
//  TracyBaseViewController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/15.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TracyBaseViewController : UIViewController

/** 基础网络请求 */
@property (nonatomic, strong, readonly) DDQProjectNetWork *netWork;


/** 控制器名字 */
@property (nonatomic, strong) NSString *controllerName;

/** 名字的润色 */
@property (nonatomic, strong) UIColor *nameColor;

/** 左按钮的View */
@property (nonatomic, strong) UIView *leftCustomView;

/** 右按钮的View */
@property (nonatomic, strong) UIView *rightCustomView;

@property (nonatomic, strong) MBProgressHUD *hud;//菊花

@property ( strong, nonatomic) MBProgressHUD *wait_hud;

/** 基础url */
@property (nonatomic, strong, readonly) NSString *baseUrl;

/** 出现10.11.12errorcode 随时准备跳的控制器 - - */
@property (nonatomic, strong) UINavigationController *loginNav;

- (void)showHud;

- (void)endHud;


@end
