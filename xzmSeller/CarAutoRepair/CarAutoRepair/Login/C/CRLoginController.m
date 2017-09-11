//
//  CRLoginController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/15.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRLoginController.h"
#import "TracyTabBarController.h"
#import "CRRegistController.h"
#import "CRThirdPartLoginController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ISAddressHelp.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

typedef NS_ENUM(NSInteger, CRLoginType) {
    
    CRLoginYanZhengType  = 0,
    CRLoginPasswordType  = 1
};

@interface CRLoginController () <MBProgressHUDDelegate>

/** 电话 */
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;
/** 验证码 */
@property (weak, nonatomic) IBOutlet UITextField *yanzmaLabel;
/** 验证码按钮 */
@property (weak, nonatomic) IBOutlet UIButton *yanzmaBtn;
/** 验证码宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yanzmaMargin;
/** 密码登录 */
@property (weak, nonatomic) IBOutlet UIButton *pwLogBtn;
/** 验证码图标 */
@property (weak, nonatomic) IBOutlet UIImageView *yanzmaImageV;

@property (weak, nonatomic) IBOutlet UIView *thirdPartLoginView;

@property (nonatomic, assign) CRLoginType loginType;

@end

@implementation CRLoginController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    
  /** 有值跳首页 */
    /** 有值请求init */
    if (kHDUserId) {
        
        if ([[kUSER_DEFAULT objectForKey:@"thirdPart"] isEqualToString:@"thirdPart"]) {
            
            [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
            
            return;
        }

        [self requestInit];
    }
}

- (void)requestInit {
    
    NSString *initUrl = [BaseURL stringByAppendingString:@"user/Init.php"];
    
    NSArray *array = @[kHDUserId];
    
    [self.netWork asyncAFNPOST:initUrl Param:array Success:^(id responseObjc, NSError *codeErr) {
        
        NSLog(@"%@",responseObjc);
        
        if (!codeErr) {
            
            [kUSER_DEFAULT setValue:responseObjc[@"picture"] forKey:@"userPicture"];
            [kUSER_DEFAULT setValue:responseObjc[@"nickname"] forKey:@"usernickname"];
            
            [kUSER_DEFAULT setValue:@"nothirdPart" forKey:@"thirdPart"];

            /** 登录环信 */
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                EMError *error = [[EMClient sharedClient] loginWithUsername:[@"sell" stringByAppendingString:responseObjc[@"userid"]] password:responseObjc[@"tel"]];
                if (!error) {
                    
                    NSLog(@"登录成功");
                }
            });

            TracyTabBarController *tabBarC = [[TracyTabBarController alloc] init];
            [self.navigationController pushViewController:tabBarC animated:NO];
            
        } else {
            
        }
    } Failure:^(NSError *netErr) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 添加手势 */
    UITapGestureRecognizer *thirdTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickThirdTap)];
    [self.thirdPartLoginView addGestureRecognizer:thirdTap];
    
    self.loginType = CRLoginYanZhengType;
}

- (void)clickThirdTap {
    
    CRThirdPartLoginController *thirdC = [[CRThirdPartLoginController alloc] init];
    thirdC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    thirdC.definesPresentationContext = YES;
    [self presentViewController:thirdC animated:YES completion:nil];
    
    /** 登录成功 */
    thirdC.loginSuccessBlock = ^() {
      
        TracyTabBarController *tabBarC = [[TracyTabBarController alloc] init];
        [self.navigationController pushViewController:tabBarC animated:YES];
    };
}

/** 注册 */
- (IBAction)registBtnAction {
    
    CRRegistController *registC = [[CRRegistController alloc] init];
    [self.navigationController pushViewController:registC animated:YES];
    
}

/** 密码登录 */
- (IBAction)passwordLogin:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected == NO) {
        self.yanzmaLabel.placeholder = @"请输入验证码";
        self.yanzmaLabel.secureTextEntry = NO;
        self.yanzmaLabel.text = nil;
        self.yanzmaMargin.constant = 93;
        [self.pwLogBtn setTitle:@"密码登录" forState:UIControlStateNormal];
        self.yanzmaImageV.image = kImage(@"skin_yanzhengma");
        self.loginType = CRLoginYanZhengType;
        
    } else {
        self.yanzmaLabel.placeholder = @"请输入密码";
        self.yanzmaLabel.secureTextEntry = YES;
        self.yanzmaLabel.text = nil;
        self.yanzmaMargin.constant = 0;
        [self.pwLogBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
        self.yanzmaImageV.image = kImage(@"qixiu_mima");
        
        self.loginType = CRLoginPasswordType;
    }
}

/** 验证码 */
- (IBAction)yanzhengmaAction:(UIButton *)sender {
    
    NSString *loginUrl = [BaseURL stringByAppendingString:@"duanxin/SendCode.php"];
    
    /** 验证手机号 */
    if ([SuperHelper isEmpty:self.phoneLabel.text]) {
        
        [MBProgressHUD buildHudWithtitle:@"请填写手机号" superView:self.view];
        return;
    }
    /*
    if (![SuperHelper checkPhoneNum:self.phoneLabel.text]) {
        
        [MBProgressHUD buildHudWithtitle:@"手机号格式不正确" superView:self.view];
        return;
    }
    */
    [self showHud];
    
    [self.netWork asyncAFNPOST:loginUrl Param:@[self.phoneLabel.text] Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        
        if (!codeErr) {
            
            [MBProgressHUD buildHudWithtitle:@"短信发送成功，请稍等！" superView:self.view];
            
            __block int timeout = 60; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.yanzmaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        self.yanzmaBtn.titleLabel.font = KFont(14);
                        self.yanzmaBtn.userInteractionEnabled = YES;
                    });
                    
                } else {
                    
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [self.yanzmaBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        self.yanzmaBtn.titleLabel.font = KFont(14);
                        self.yanzmaBtn.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                /** 跳转登录 */
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
            } else if (code == 13) {
                [MBProgressHUD buildHudWithtitle:@"手机号格式不符合要求" superView:self.view];
            } else {
                [MBProgressHUD buildHudWithtitle:@"验证码发送失败，请稍后再试！" superView:self.view];
            }
        }
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD buildHudWithtitle:@"无法连接到网络，请稍后再试!" superView:self.view];
    }];
}

/** 登录 */
- (IBAction)loginBtnAction {
    
    /** 验证手机号 */
    if ([SuperHelper isEmpty:self.phoneLabel.text]) {
        
        [MBProgressHUD buildHudWithtitle:@"请填写手机号" superView:self.view];
        return;
    }
    
    /*
    if (![SuperHelper checkPhoneNum:self.phoneLabel.text]) {
        
        [MBProgressHUD buildHudWithtitle:@"手机号格式不正确" superView:self.view];
        return;
    }
    */
    NSString *loginUrl = nil;
    
    if (self.loginType == CRLoginYanZhengType) {
        
        loginUrl = [BaseURL stringByAppendingString:@"user/LoginByCode.php"];
        
        if ([SuperHelper isEmpty:self.yanzmaLabel.text]) {
            
            [MBProgressHUD buildHudWithtitle:@"请填写验证码" superView:self.view];
            return;
        }
        
    } else {
        
        loginUrl = [BaseURL stringByAppendingString:@"user/Login.php"];
        
        if ([SuperHelper isEmpty:self.yanzmaLabel.text]) {
            
            [MBProgressHUD buildHudWithtitle:@"请填写验证码" superView:self.view];
            return;
        }
        
        if (![SuperHelper checkPassword:self.yanzmaLabel.text]) {
            
            [MBProgressHUD buildHudWithtitle:@"验证码格式不符合要求" superView:self.view];
            return;
        }
        
        
    }
    
    [self showHud];

    [self.netWork asyncAFNPOST:loginUrl Param:@[self.phoneLabel.text,self.yanzmaLabel.text] Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        
        if (!codeErr) {

            [kUSER_DEFAULT setValue:responseObjc[@"userid"] forKey:@"userId"];
            [kUSER_DEFAULT setValue:responseObjc[@"picture"] forKey:@"userPicture"];
            [kUSER_DEFAULT setValue:responseObjc[@"nickname"] forKey:@"usernickname"];
            
            [kUSER_DEFAULT setValue:@"nothirdPart" forKey:@"thirdPart"];

            [MBProgressHUD alertHUDInView:self.view Text:@"登录成功!" Delegate:self];
            
            /** 登录环信 */
          
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                EMError *error = [[EMClient sharedClient] loginWithUsername:[@"sell" stringByAppendingString:responseObjc[@"userid"]] password:self.phoneLabel.text];
                if (!error) {
                    
                    NSLog(@"登录成功");
                }
            /*
                else {
                    
                    EMError *error1 = [[EMClient sharedClient] registerWithUsername:[@"sell" stringByAppendingString:responseObjc[@"userid"]] password:self.phoneLabel.text];
                }
             */
            });
            
        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                /** 跳转登录 */
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
            } else if (code == 13) {
                [MBProgressHUD buildHudWithtitle:@"手机号格式不符合要求" superView:self.view];
            } else if (code == 14 || code == 17) {
                [MBProgressHUD buildHudWithtitle:@"密码不正确，请重新输入" superView:self.view];
            } else if (code == 16) {
                [MBProgressHUD buildHudWithtitle:@"用户不存在" superView:self.view];
            } else if (code == 19) {
                [MBProgressHUD buildHudWithtitle:@"电话已经被注册" superView:self.view];
            } else if (code == 49) {
                [MBProgressHUD buildHudWithtitle:@"验证码格式不符合要求" superView:self.view];
            } else if (code == 50 || code == 51) {
                [MBProgressHUD buildHudWithtitle:@"验证码不匹配" superView:self.view];
            } else {
                [MBProgressHUD buildHudWithtitle:@"服务器繁忙，请稍后重试!" superView:self.view];
            }
        }
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD buildHudWithtitle:@"无法连接到网络，请稍后再试!" superView:self.view];
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    TracyTabBarController *tabBarC = [[TracyTabBarController alloc] init];
    [self.navigationController pushViewController:tabBarC animated:YES];
    
}

#pragma mark - 实现TextField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.yanzmaLabel) {
        [self loginBtnAction];
    }
    return YES;
}





@end
