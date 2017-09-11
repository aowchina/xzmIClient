//
//  UINavigationController+NavShowHud.m
//  HengDuWS
//
//  Created by min－fo018 on 16/7/13.
//  Copyright © 2016年 北京银河盛泰科技有限公司. All rights reserved.
//

#import "UINavigationController+NavShowHud.h"

@implementation UINavigationController (NavShowHud)

@dynamic showHud;

- (void)setShowHud:(BOOL)showHud {

    if (showHud) {
        
        MBProgressHUD *hud = [MBProgressHUD instanceHudInView:self.view Text:@"检测到您的账号出现异常" Mode:MBProgressHUDModeText Delegate:nil];
        [hud hide:YES afterDelay:1.5];
        
    }
    
}

@end
