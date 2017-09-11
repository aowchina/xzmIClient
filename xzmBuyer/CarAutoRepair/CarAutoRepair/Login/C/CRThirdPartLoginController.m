//
//  CRThirdPartLoginController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/18.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRThirdPartLoginController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"

@interface CRThirdPartLoginController ()<MBProgressHUDDelegate>


@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation CRThirdPartLoginController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 添加手势 */
    UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackViewTap)];
    [self.backView addGestureRecognizer:backViewTap];
    
}

/** 微信登录 */
- (IBAction)clickWeChatBtnAction:(UIButton *)sender {
    
    //    配件商  wx9b8bd56c56ab2c7b  132d1e039c3cf142ae590eecaa24d58f
    
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            NSLog(@"%@,%@",user.uid,user.icon);
            NSString *thirdLoginUrl = [BaseURL stringByAppendingString:@"user/LoginByDsf.php"];
            NSArray *arr = @[user.uid,@"1",[SuperHelper changeStringUTF:user.nickname],user.icon];
            [self showHud];
            
            [self.netWork asyncAFNPOST:thirdLoginUrl Param:arr  Success:^(id responseObjc, NSError *codeErr) {
                [self endHud];
                
                NSInteger code = codeErr.code;
                NSLog(@"%ld",(long)code);
                
                if (!codeErr) {
                    
                    [kUSER_DEFAULT setValue:responseObjc[@"userid"] forKey:@"userId"];
                    [kUSER_DEFAULT setValue:responseObjc[@"picture"] forKey:@"userPicture"];
                    [kUSER_DEFAULT setValue:responseObjc[@"nickname"] forKey:@"usernickname"];
                    
                    [kUSER_DEFAULT setValue:@"thirdPart" forKey:@"thirdPart"];
                    
                    [ISAddressHelp shareInstance].loginType = @"100";
                    
                    //NSString *str = user.uid;
                    /*
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        EMError *error1 = [[EMClient sharedClient] registerWithUsername:[@"buy" stringByAppendingString:responseObjc[@"userid"]] password:str];
                        if (error1==nil) {
                            NSLog(@"注册成功");
                            
                            EMError *error = [[EMClient sharedClient] loginWithUsername:[@"buy" stringByAppendingString:responseObjc[@"userid"]] password:user.uid];
                            if (!error) {
                                
                                NSLog(@"登录成功");
                            } else {
                                
                                EMError *error1 = [[EMClient sharedClient] registerWithUsername:[@"buy" stringByAppendingString:responseObjc[@"userid"]] password:user.uid];
                            }

                            
                            
                        } else {
                            
                            NSLog(@"%@",error1);
                            
                            EMError *error = [[EMClient sharedClient] loginWithUsername:[@"buy" stringByAppendingString:responseObjc[@"userid"]] password:user.uid];
                            if (!error) {
                                
                                NSLog(@"登录成功");
                            }
                            
                        }
                    });
                    */
                    /** 登录环信 */
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        EMError *error = [[EMClient sharedClient] loginWithUsername:[@"buy" stringByAppendingString:responseObjc[@"userid"]] password:user.uid];
                        if (!error) {
                            
                            NSLog(@"登录成功");
                        }
                    });
                    
                    [MBProgressHUD alertHUDInView:self.view Text:@"登录成功!" Delegate:self];
                    
                } else {
                    [MBProgressHUD buildHudWithtitle:@"嗯嗯，出了点问题，请稍后重试!" superView:self.view];
                }
            } Failure:^(NSError *netErr) {
                [self endHud];
                [MBProgressHUD buildHudWithtitle:@"无法连接到网络，请稍后再试!" superView:self.view];
            }];
            
        } else {
            
            NSLog(@"%@",error);
        }
        
    }];
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if (_loginSuccessBlock) {
        _loginSuccessBlock();
    }
}

- (void)clickBackViewTap {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
