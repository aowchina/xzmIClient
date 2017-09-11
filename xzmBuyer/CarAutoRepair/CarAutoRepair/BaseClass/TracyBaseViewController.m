//
//  TracyBaseViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/15.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"
#import "CRLoginController.h"

@interface TracyBaseViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIBarButtonItem *leftItem;

@property (nonatomic, strong) UIImageView *navBarImageView;

@end

@implementation TracyBaseViewController

@synthesize netWork = _netWork;

/** 网络请求 */
- (DDQProjectNetWork *)netWork {
    
    if (!_netWork) {
        
        _netWork = [DDQProjectNetWork sharedNetWork];
        
    }
    
    return _netWork;
    
}

- (NSString *)baseUrl {

//    return @"http://192.168.1.110/zjxzm/api/users/";
    
//    http://zjxzm.min-fo.com/api/
    
    return @"http://zjxzm.min-fo.com/api/users/";

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CGRect newStatusBarFrame = [(NSValue*)[notification.userInfo objectForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    
//    CGFloat OffsetY = IS_HOTSPOT_CONNECTED?+HOTSPOT_STATUSBAR_HEIGHT:-HOTSPOT_STATUSBAR_HEIGHT;
//    CGPoint newCenter = CGPointZero;
    
    
    
    
//    self.navigationController.navigationBar.frame = CGRectMake(0, 0, kScreenWidth, 44);
//    
//    self.navigationController.navigationBar.translucent = NO;
    
//    newCenter = self.navigationController.navigationBar.center;
//    
//    newCenter.y -= OffsetY;
//    
//    self.navigationController.view.center = newCenter;
//    
//    self.navigationController.navigationBar.center = newCenter;
    
    
//    if (IS_HOTSPOT_CONNECTED) {
//        NSLog(@"aaaa");
//        
//        newCenter.y += OffsetY;
//        
//        self.view.center = newCenter;
//        
//    } else {
//        
//        NSLog(@"bbb");
//    }
    
    /** 电池栏白色 */
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //    //    //bar的背景图
//        [self.navigationController.navigationBar setBackgroundImage:kImage(@"NavBarImg") forBarMetrics:UIBarMetricsDefault];
    
    //    [[UITextField appearance] setTintColor:ColorForRGB(0x6b535a)];
    
    //确保唯一的title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.5, 30)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:17.0];
    self.navigationItem.titleView = self.titleLabel;
    
    //左按钮
    self.leftItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.leftBarButtonItem = self.leftItem;
}

/** 设置控制器的名称 */
- (void)setControllerName:(NSString *)controllerName {
    
    _controllerName = controllerName;
    
    self.titleLabel.text = controllerName;
    
}

/** 设置控制器名称的一些属性 */
- (void)setNameColor:(UIColor *)nameColor {
    
    if (!nameColor) {
        nameColor = ColorForRGB(0x000000);
    }
    
    self.titleLabel.textColor = nameColor;
    
}

/** 左按钮 */
- (void)setLeftCustomView:(UIView *)leftCustomView {
    
    self.leftItem.customView = leftCustomView;
}

- (UINavigationController *)loginNav {
    
    if (!_loginNav) {
        
        _loginNav = [[UINavigationController alloc] initWithRootViewController:[[CRLoginController alloc] initWithNibName:@"CRLoginController" bundle:nil]];
        
        [kUSER_DEFAULT setValue:@"nothirdPart" forKey:@"thirdPart"];
        [kUSER_DEFAULT removeObjectForKey:@"userId"];
        
        _loginNav.showHud = YES;
        
    }
    
    return _loginNav;
    
}

/**
 *  这是为了不出现customview重叠的情况
 *
 */
- (MBProgressHUD *)wait_hud {
    
    if (!_wait_hud) {
        
        _wait_hud = [[MBProgressHUD alloc] initWithView:self.view];
        _wait_hud.labelText = @"等待中...";
        [self.view addSubview:_wait_hud];
    }
    
    return _wait_hud;
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] init];
    }
    return _hud;
}

- (void)showHud {
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"等待中...";
    [self.hud show:YES];
    
}

- (void)endHud {
    
    [self.hud hide:YES];
    [self.hud removeFromSuperViewOnHide];
}



@end
