//
//  MBProgressHUD+ShowHUD.m
//  HengDuWS
//
//  Created by min－fo018 on 16/6/29.
//  Copyright © 2016年 北京银河盛泰科技有限公司. All rights reserved.
//

#import "MBProgressHUD+ShowHUD.h"

//#import "DDQLoadingGif.h"

@implementation MBProgressHUD (ShowHUD)

//一个用来提示一下的hud
+ (void)alertHUDInView:(UIView *)view Text:(NSString *)text {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    
    [hud hide:YES afterDelay:1.0];
    hud.removeFromSuperViewOnHide = YES;
    
}

//一个实现代理的hud
static MBProgressHUD *GIFHUD = nil;
+ (void)alertHUDInView:(UIView *)view Text:(NSString *)text Delegate:(id<MBProgressHUDDelegate>)delegate {
    
    GIFHUD = nil;
    GIFHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    GIFHUD.mode = MBProgressHUDModeText;
    GIFHUD.detailsLabelText = text;
    GIFHUD.labelFont = [UIFont systemFontOfSize:15.0f];
    [GIFHUD hide:YES afterDelay:1.5];
    GIFHUD.removeFromSuperViewOnHide = YES;
    GIFHUD.delegate = delegate;
}

+ (void)alertHUDReleaseDelegate {

    GIFHUD.delegate = nil;
}

+ (instancetype)instanceHudInView:(UIView *)view Text:(NSString *)text Mode:(MBProgressHUDMode)mode Delegate:(id<MBProgressHUDDelegate>)delegate {
    
    return [[self alloc] initWithView:view Text:text Mode:mode Delegate:delegate];
}

- (instancetype)initWithView:(UIView *)view Text:(NSString *)text Mode:(MBProgressHUDMode)mode Delegate:(id<MBProgressHUDDelegate>)delegate {
    
    self = [super init];
    
    if (self) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        
        hud.delegate = delegate;
        
        if (text) {
            
            hud.detailsLabelText = text;
        } else {
            
            hud.detailsLabelText = @"请稍等...";
        }
        
        hud.mode = mode;
        hud.removeFromSuperViewOnHide = YES;
        self = hud;
    }
    
    return self;
}

//适用于这个工程的hud
/*
+ (instancetype)instanceHudInView:(UIView *)view Delegate:(id<MBProgressHUDDelegate>)delegate {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.delegate = delegate;
    
    DDQLoadingGif *hudGifImageView = [[DDQLoadingGif alloc] initGifImageViewWithFrame:CGRectMake(0, 0, 120, 120) timer:3.0];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i < 7; i++) {
        
        [array addObject:kImage(@(i).stringValue)];
    }
    hudGifImageView.gifSourceContainer = array;
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.color = [UIColor clearColor];
    hud.customView = hudGifImageView;
    
    return hud;
}
*/

+ (void)buildHudWithtitle:(NSString *)title superView:(UIView *)view {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.labelFont = [UIFont systemFontOfSize:15.0f];
    [view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:2];
}


@end
