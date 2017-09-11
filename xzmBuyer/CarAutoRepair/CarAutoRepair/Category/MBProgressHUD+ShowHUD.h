//
//  MBProgressHUD+ShowHUD.h
//  HengDuWS
//
//  Created by min－fo018 on 16/6/29.
//  Copyright © 2016年 北京银河盛泰科技有限公司. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (ShowHUD)

/** 用来提示的hud */
+ (void)alertHUDInView:(UIView *)view Text:(NSString *)text;

/** alert并遵循hud代理 */
+ (void)alertHUDInView:(UIView *)view Text:(NSString *)text Delegate:(id<MBProgressHUDDelegate>)delegate;

/** 便利构造器 */
+ (instancetype)instanceHudInView:(UIView *)view Text:(NSString *)text Mode:(MBProgressHUDMode)mode Delegate:(id<MBProgressHUDDelegate>)delegate;

/** 便利构造器:适用于这个工程的hud */
//+ (instancetype)instanceHudInView:(UIView *)view Delegate:(id<MBProgressHUDDelegate>)delegate;

/** 取消当前GIFHUD的代理 */
+ (void)alertHUDReleaseDelegate;

+ (void)buildHudWithtitle:(NSString *)title superView:(UIView *)view;
@end
