//
//  HDChangePasswordController.m
//  HengDuWS
//
//  Created by minfo019 on 16/7/11.
//  Copyright © 2016年 北京银河盛泰科技有限公司. All rights reserved.
//

#import "HDChangePasswordController.h"
#import "CRLoginController.h"

@interface HDChangePasswordController ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordF;
@property (weak, nonatomic) IBOutlet UITextField *newpassTextF;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordF;

@end

@implementation HDChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
}

- (void)setupNav {
    
    /** 设置标题 */
    self.controllerName = @"修改密码";
    /** 右按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.oldPasswordF.layer.borderWidth = 1.0f;
    self.oldPasswordF.layer.borderColor = ColorForRGB(0x828282).CGColor;
    self.newpassTextF.layer.borderWidth = 1.0f;
    self.newpassTextF.layer.borderColor = ColorForRGB(0x828282).CGColor;
    self.surePasswordF.layer.borderWidth = 1.0f;
    self.surePasswordF.layer.borderColor = ColorForRGB(0x828282).CGColor;
}

#pragma mark - BarButtonItemAction
- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureBtn:(UIButton *)sender {
    
    if ([self.oldPasswordF.text isEqualToString:@""]) {
        [MBProgressHUD buildHudWithtitle:@"请填写原始密码！" superView:self.view];
        return;
    }
    
    if ([self.newpassTextF.text isEqualToString:@""]) {
        [MBProgressHUD buildHudWithtitle:@"请填写新密码！" superView:self.view];
        return;
    }
    
    if ([self.surePasswordF.text isEqualToString:@""]) {
        [MBProgressHUD buildHudWithtitle:@"请填写确认密码！" superView:self.view];
        return;
    }
    
    if ([SuperHelper checkPassword:self.oldPasswordF.text]) {
        if ([SuperHelper checkPassword:self.newpassTextF.text]) {
            if ([SuperHelper checkPassword:self.surePasswordF.text]) {
                if ([self.newpassTextF.text isEqualToString:self.surePasswordF.text]) {
                    NSString *Edit_Url = [self.baseUrl stringByAppendingString:@"user/EditPsw.php"];
                    NSArray *array = @[kHDUserId,self.oldPasswordF.text,self.newpassTextF.text,self.surePasswordF.text];
                    [self showHud];
                    [self.netWork asyncAFNPOST:Edit_Url Param:array Success:^(id responseObjc, NSError *codeErr) {
                        [self endHud];
                        if (!codeErr) {
                            [MBProgressHUD alertHUDInView:self.view Text:@"修改成功!" Delegate:self];
                        } else {
                            NSInteger code = codeErr.code;
                            if (code == 10 || code == 11 || code == 12) {
                                /** 跳转登录 */
                                [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CRLoginController alloc] init]];
                            } else if (code == 14) {
                                [MBProgressHUD buildHudWithtitle:@"密码格式不符合要求" superView:self.view];
                            } else if (code == 18) {
                                [MBProgressHUD buildHudWithtitle:@"两次密码输入不一致" superView:self.view];
                            } else if (code == 17) {
                                [MBProgressHUD buildHudWithtitle:@"密码输入有误" superView:self.view];
                            } else {
                                [MBProgressHUD buildHudWithtitle:@"服务器繁忙，请稍后重试!" superView:self.view];
                            }
                        }
                    } Failure:^(NSError *netErr) {
                        [self endHud];
                        [MBProgressHUD buildHudWithtitle:@"无法连接到网络，请稍后再试!" superView:self.view];
                    }];
                } else {
                    [MBProgressHUD buildHudWithtitle:@"两次密码输入不一致" superView:self.view];
                }
            } else {
                [MBProgressHUD buildHudWithtitle:@"确认密码输入不合法" superView:self.view];
            }
        } else {
            [MBProgressHUD buildHudWithtitle:@"新密码输入不合法" superView:self.view];
        }
    } else {
        [MBProgressHUD buildHudWithtitle:@"原密码输入不合法" superView:self.view];
    }
}

- (IBAction)cancelBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
