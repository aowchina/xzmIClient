//
//  CRSendViewController.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRSendViewController.h"
#import "CRWuLiuListModel.h"


@interface CRSendViewController ()<tracy_pickViewDelegate>
/** 蒙版 */
@property (strong, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *sendBbackView;

/** 白背景 */
@property (weak, nonatomic) IBOutlet UIView *whiteView;
/** 快递公司 */
@property (weak, nonatomic) IBOutlet UIButton *chooseWuLiuBtn;
/** 快递单号 */
@property (weak, nonatomic) IBOutlet UITextField *wuLiuNum;

@end

@implementation CRSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _whiteView.layer.cornerRadius = 5;
    _whiteView.layer.masksToBounds = YES;
    
    // 加个手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.sendBbackView addGestureRecognizer:tapGesture];

}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 选择物流点击
- (IBAction)chooseWuLiu:(id)sender
{
    TracyPickView *tracyView = [TracyPickView pickViewWithArray:self.wuLiuArr];
    
    tracyView.delegate = self;
    
    [self.view endEditing:YES];
}

#pragma mark - tracy_pickViewDelegate
- (void)chooseBank:(NSString *)bank andIndex:(NSInteger)index
{
    [_chooseWuLiuBtn setTitle:bank forState:UIControlStateNormal];
}

#pragma mark - 确定点击
- (IBAction)sureBtnClick:(id)sender
{
    NSLog(@"%@",_chooseWuLiuBtn.titleLabel.text);
    
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"确认发货信息是否正确"];
    [alert addBtnTitle:@"取消" action:^{
        
    }];
    
    [alert addBtnTitle:@"确定" action:^{
        
        if ([_chooseWuLiuBtn.titleLabel.text isEqualToString:@"选择快递公司"])
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请先选择快递公司"];
            return;
        }
        
        if (_wuLiuNum.text.length == 0)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请输入快递单号"];
            return;
        }
        
        [self requestSendWuLiuName:_chooseWuLiuBtn.titleLabel.text];
        
    }];
    [alert showAlertWithSender:self];
   
}

#pragma mark - 请求发货接口
- (void)requestSendWuLiuName:(NSString *)wuLiuName
{
    NSString *wuliuID = [NSString string];
    
    for (_model in self.allData)
    {
        if ([_model.name isEqualToString:wuLiuName])
        {
            wuliuID = _model.ID;
        }
    }
    
    NSString *Send_Url = self.orderType == 1 ? [self.baseUrl stringByAppendingString:@"order/GoGoods.php"] : [self.baseUrl stringByAppendingString:@"qgorder/GoGoods.php"];
    
    NSArray *arr = @[kHDUserId,self.orderID,_wuLiuNum.text,wuliuID];
    [self showHud];
    [self.netWork asyncAFNPOST:Send_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"发货成功" ];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
        else if (code == 11)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"账号异常，请重新登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else if (code == 12)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"用户未登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else if (code == 29 || code  == 30)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"订单不存在或是已取消"];
        }
        else if (code == 49)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"该订单已发货，请收货后再退货"];
        }
        else if (code == 50)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请填写运单号"];
        }
        else if (code == 51)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请填写快递方式"];
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


@end
