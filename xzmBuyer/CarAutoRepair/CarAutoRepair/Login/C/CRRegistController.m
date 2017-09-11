//
//  CRRegistController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/18.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRRegistController.h"

@interface CRRegistController ()<MBProgressHUDDelegate>

/** 手机号 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;

@property (weak, nonatomic) IBOutlet UITextField *yanzmaTextF;/** 验证码 */
/** 发送验证码按钮 */
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwTextF;/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *surepwTextF;/** 确认密码 */


@end

@implementation CRRegistController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pwTextF.secureTextEntry = YES;
    _surepwTextF.secureTextEntry = YES;
}

/** 验证码按钮 */
- (IBAction)yanzmaBtnAction:(UIButton *)sender
{
    if (self.phoneTextF.text.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"请输入手机号"];
        return;
    }
    
    NSString *Code_Url = [self.baseUrl stringByAppendingString:@"duanxin/SendCode.php"];
    NSArray *arr = @[self.phoneTextF.text];
    [self showHud];
    [self.netWork asyncAFNPOST:Code_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            [self setTimer];
        }
        else if (code == 9)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"短信发送失败,请稍后重试"];
        }
        else if (code == 13)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@""];
        }
        else if (code == 15)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@""];
        }
        else if (code == 49)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"短信发送失败,请稍后重试"];
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }

    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}

#pragma mark - 倒计时
- (void)setTimer
{
    //倒计时时间
    __block int timeout = 60;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    //每秒执行
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0)
        {   //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                
                _codeBtn.userInteractionEnabled = YES;
            });
        }
        else
        {
            int seconds = timeout;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //让按钮变为不可点击的灰色
                _codeBtn.userInteractionEnabled = NO;
                
                [_codeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/** 注册 */
- (IBAction)registBtnAction:(UIButton *)sender
{
    NSString *Regist_Url = [self.baseUrl stringByAppendingString:@"user/Apply.php"];
    NSArray *arr = @[self.phoneTextF.text,self.pwTextF.text,self.surepwTextF.text,self.yanzmaTextF.text,@"0"];
    [self showHud];
    [self.netWork asyncAFNPOST:Regist_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {         
            [MBProgressHUD alertHUDInView:self.view Text:@"注册成功!" Delegate:self];
            
//            NSString *str = self.phoneTextF.text;
//            
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                
//                EMError *error1 = [[EMClient sharedClient] registerWithUsername:[@"BUY" stringByAppendingString:responseObjc] password:str];
//                if (error1==nil) {
//                    NSLog(@"注册成功");
//                } else {
//                    
//                    NSLog(@"%@",error1);
//                    
//                }
//            });
//
        }
        else if (code == 13)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"两次密码输入不一致"];
        }
        else if (code == 14)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"密码非法"];
        }
        else if (code == 18)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"两次密码输入不一致"];
        }
        else if (code == 19)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"账号已存在"];
        }
        else if (code == 50 || code == 51)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"验证码不正确"];
        }
        else if (code == 63)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"注册失败，请重新注册"];
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}

/** 退回登录 */
- (IBAction)loginBtnAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
