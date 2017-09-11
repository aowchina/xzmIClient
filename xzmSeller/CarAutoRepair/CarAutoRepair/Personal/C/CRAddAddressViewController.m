//
//  CRAddAddressViewController.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAddAddressViewController.h"


@interface CRAddAddressViewController ()<MBProgressHUDDelegate>
/** 收货人姓名 */
@property (weak, nonatomic) IBOutlet UITextField *receiveName;
/** 手机号 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
/** 省市区按钮 */
@property (weak, nonatomic) IBOutlet UIButton *chooseCityBtn;
/** 收货地址 */
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;

@property (nonatomic, strong) ISAddressProvinceModel *pmodel;
@property (nonatomic, strong) ISAddressCityModel *citymodel;
@property (nonatomic, strong) ISAddressCountryModel *coumodel;

@end

@implementation CRAddAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav]; 
}

- (void)setupNav
{
    self.controllerName = @"添加地址";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - BarButtonItemAction
- (void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 选择省市区
- (IBAction)chooseCity:(id)sender
{
    HDPickViewController *pickVC = [[HDPickViewController alloc] init];
    self.definesPresentationContext = YES;
    pickVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    pickVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    pickVC.block = ^(ISAddressProvinceModel *isPmodel,ISAddressCityModel *isCitymodel,ISAddressCountryModel *isCoumodel) {
        self.pmodel = isPmodel;
        self.citymodel = isCitymodel;
        self.coumodel = isCoumodel;
        NSString *areaName;
        if (self.coumodel.name == nil) {
            areaName = @"";
        } else {
            areaName = self.coumodel.name;
        }
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@",self.pmodel.name,self.citymodel.name,areaName];
        [self.chooseCityBtn setTitle:str forState:UIControlStateNormal];
    };
    [self presentViewController:pickVC animated:YES completion:^{
    }];
}

#pragma mark - 保存地址点击
- (IBAction)keepBtnClick:(id)sender
{
    NSLog(@"保存地址");
    if (_receiveName.text.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"请输入收货人姓名"];
        return;
    }
    if (_phoneNumber.text.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"请输入手机号"];
        return;
    }
    if (_chooseCityBtn.titleLabel.text.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"请选择省市区"];
        return;
    }
    if (_detailAddress.text.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"详细地址"];
        return;
    }
    
    NSString *Addaddress_Url = [self.baseUrl stringByAppendingString:@"user/AddressAdd.php"];
    
    NSArray *arr = @[kHDUserId,[SuperHelper changeStringUTF:self.receiveName.text],self.phoneNumber.text,self.pmodel.id,self.citymodel.id,self.coumodel.id,[SuperHelper changeStringUTF:self.detailAddress.text]];
    
    [self showHud];
    [self.netWork asyncAFNPOST:Addaddress_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"添加成功!" Delegate:self];
        }
        else if (code == 49)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@""];
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

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
