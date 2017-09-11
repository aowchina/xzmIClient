//
//  CRMakeSureViewController.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRMakeSureViewController.h"
#import "CRMakeSureHeaderView.h"
#import "CROrderDetailCell.h"
#import "CROrderDetailModel.h"
#import "CRAddressViewController.h"
#import "KTPayBottomView.h"

#import "DDQAlipay.h"
#import "DDQWXPay.h"

@interface CRMakeSureViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>

@property (nonatomic ,strong) CRMakeSureHeaderView *headerView;
/** 列表 */
@property (nonatomic ,strong) UITableView *tableView;
/** 数据 */
@property (nonatomic ,strong) NSMutableArray *dataArr;
/** 订单号 */
@property (nonatomic ,strong) UILabel *numberLabel;
/** 下单时间 */
@property (nonatomic ,strong) UILabel *timelabel;
/** 底部总价 */
@property (nonatomic ,strong) UILabel *totalPriceLabel;
/** 取消订单按钮 */
@property (nonatomic ,strong) UIButton *cancelBtn;
/** 立即支付按钮 */
@property (nonatomic ,strong) UIButton *payBtn;
/** 蒙版 */
@property (nonatomic ,strong) UIView *maskView;
/** 底部支付view */
@property (nonatomic ,strong) KTPayBottomView *payView;
/** 下单时间 */
@property (nonatomic ,strong) NSString *orderTime;
/** 合计总价 */
@property (nonatomic ,strong) NSString *price;

@end

@implementation CRMakeSureViewController

static NSString *listCell = @"cell";


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    [self requestData];
    
    [self creatTableView];
    
    [self creatBottomView];
    
    [self creatPayBottomView];
}

- (void)setupNav
{
    self.controllerName = @"确认订单";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - BarButtonItemAction
- (void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据
- (void)requestData
{
    
    NSString *MakeSure_Url = self.orderType == GoodsOrderType ? [self.baseUrl stringByAppendingString:@"order/MakeSure.php"] : [self.baseUrl stringByAppendingString:@"qgorder/MakeSure.php"];
    
    NSArray *arr = @[kHDUserId,self.orderID];
    [self showHud];
    [self.netWork asyncAFNPOST:MakeSure_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        self.dataArr = [NSMutableArray arrayWithCapacity:1];
        
        if (!code)
        {
            if (self.orderType == GoodsOrderType) {
                // 收货人姓名
                self.headerView.nameLabel.text = responseObjc[@"user_name"];
                // 手机号
                self.headerView.phoneLabel.text = responseObjc[@"user_tel"];
                // 地址
                self.headerView.addressLabel.text = responseObjc[@"user_address"];
                // 下单时间
                self.orderTime = responseObjc[@"addtime"];
            } else {
                
                // 收货人姓名
                self.headerView.nameLabel.text = responseObjc[@"qg_user_name"];
                // 手机号
                self.headerView.phoneLabel.text = responseObjc[@"qg_user_tel"];
                // 地址
                self.headerView.addressLabel.text = responseObjc[@"qg_user_address"];
                // 下单时间
                self.orderTime = responseObjc[@"addtime"];
                
            }
            
            for (NSDictionary *dic in responseObjc[@"goods"])
            {
                CROrderDetailModel *model = [CROrderDetailModel mj_objectWithKeyValues:dic];
                
                model.orderType = self.orderType;
                
                [self.dataArr addObject:model];
            }
            
            if (self.orderType == QGOrderType) {
                
                NSString *totalPriceStr = [NSString stringWithFormat:@"%.2f",[responseObjc[@"total_money"] floatValue]];
                _totalPriceLabel.text = [NSString stringWithFormat:@"￥%@",totalPriceStr];
            } else {
                [self countPrice];
            }
            
            [self.tableView reloadData];
            
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
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}

#pragma markr - 底部支付view
- (void)creatPayBottomView
{
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - IS_HOTSPOT_HEIGHT)];
    _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.5];
    [self.view addSubview:_maskView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMaskView)];
    [tapGesture setNumberOfTapsRequired:1];
    [_maskView addGestureRecognizer:tapGesture];
    
    _payView = [[KTPayBottomView alloc] init];
    [_maskView addSubview:_payView];
    [_payView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.mas_equalTo(_maskView.mas_bottom);
        make.height.mas_equalTo(200);
    }];
    
    // 取消按钮
    //    __weak typeof(self)wself = self;
    @weakify(self);
    _payView.cancelPayBlock = ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [weak_self closeMaskView];
        }];
    };
    
    // 支付宝支付
    _payView.aliPayActionBlock = ^{
        
        [weak_self closeMaskView];
        
        NSString *str = self.orderType == GoodsOrderType ? [NSString stringWithFormat:@"%@%@",weak_self.baseUrl,@"order/ZfbPay.php"] : [NSString stringWithFormat:@"%@%@",weak_self.baseUrl,@"qgorder/ZfbPay.php"];

        [weak_self requestAliPayUrl:str];
        
    };
    
    // 余额支付
    _payView.balanceActionVlock = ^{
        
        [weak_self closeMaskView];
        
        ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"是否要用钱包余额购买该商品？"];
        [alert addBtnTitle:@"取消" action:^{
            
            
        }];
        [alert addBtnTitle:@"确定" action:^{
            
            [weak_self requestBalancePay];
        }];
        [alert showAlertWithSender:weak_self];
        
    };
    
    // 微信支付
    _payView.weChatPayActionBlock = ^{
        
        NSString *str = self.orderType == GoodsOrderType ? [NSString stringWithFormat:@"%@%@",weak_self.baseUrl,@"order/WxPay.php"] : [NSString stringWithFormat:@"%@%@",weak_self.baseUrl,@"qgorder/WxPay.php"];
        
        [weak_self orderScreenWXPayWithUrl:str orderStr:weak_self.orderID];
    };
}

#pragma mark - 创建表
- (void)creatTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 49 - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"CROrderDetailCell" bundle:nil] forCellReuseIdentifier:listCell];
    
    self.headerView = [[CRMakeSureHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 115)];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAddressView)];
    
    [tapGesture setNumberOfTapsRequired:1];
    
    [self.headerView addGestureRecognizer:tapGesture];
    
    _tableView.tableHeaderView = self.headerView;
    
    [self.view addSubview:_tableView];
}

- (void)clickAddressView
{
    CRAddressViewController *addressListC = [[CRAddressViewController alloc] init];
    
    addressListC.makeSureType = 1;
    
    addressListC.addressSetSuccess = ^() {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self requestData];
            
        });
    };
    
    [self.navigationController pushViewController:addressListC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CROrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
    
    if (indexPath.row < self.dataArr.count)
    {
        CROrderDetailModel *model = self.dataArr[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}

#pragma mark - tableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    customView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = ColorForRGB(0x828282);
    label.text = @"商品详情";
    label.font = [UIFont systemFontOfSize:14];
    [customView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker * make) {
        
        make.left.mas_equalTo(customView.mas_left).offset(30);
        make.top.mas_equalTo(5);
    }];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [customView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(customView.mas_bottom).offset(-1);
        make.left.mas_equalTo(customView.mas_left).offset(15);
        make.right.mas_equalTo(customView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(footerView.mas_top).offset(1);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(footerView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:13];
    // 订单编号
    _numberLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.orderID];
    [footerView addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
    }];
    
    _timelabel = [[UILabel alloc] init];
    _timelabel.font = [UIFont systemFontOfSize:13];
    // 下单时间
    _timelabel.text = [NSString stringWithFormat:@"下单时间：%@",self.orderTime];
    [footerView addSubview:_timelabel];
    [_timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_numberLabel.mas_bottom).offset(10);
    }];
    
    return footerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 65;
}

#pragma mark - 底部视图
- (void)creatBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(49);
    }];
    
    UILabel *topLine = [[UILabel alloc] init];
    topLine.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(bottomView.mas_top).offset(1);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"合计：";
    lab.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(bottomView.mas_left).offset(5);
        make.bottom.mas_equalTo(bottomView.mas_bottom).offset(-15);
    }];
    
    _totalPriceLabel = [[UILabel alloc] init];
    _totalPriceLabel.textColor = kColor(199, 0, 0);
    _totalPriceLabel.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:_totalPriceLabel];
    [_totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(lab.mas_right);
        make.bottom.mas_equalTo(bottomView.mas_bottom).offset(-15);
    }];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payBtn setBackgroundColor:kColor(199, 0, 0)];
    [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_payBtn];
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(bottomView.mas_right);
        make.width.mas_equalTo(kScreenWidth / 3.7);
        make.bottom.mas_equalTo(bottomView.mas_bottom);
        make.top.mas_equalTo(bottomView.mas_top);
    }];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setBackgroundColor:kColor(139, 140, 141)];
    [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_payBtn.mas_left);
        make.width.mas_equalTo(kScreenWidth / 3.7);
        make.bottom.mas_equalTo(bottomView.mas_bottom);
        make.top.mas_equalTo(bottomView.mas_top);
    }];
    
    
}

#pragma mark - 取消订单
- (void)cancelClick
{
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"是否要取消该订单？"];
    [alert addBtnTitle:@"取消" action:^{
        
        
    }];
    [alert addBtnTitle:@"确定" action:^{
        
        [self requestCancelOrder];
    }];
    [alert showAlertWithSender:self];
}

#pragma mark - 请求取消订单接口
- (void)requestCancelOrder
{
    
    NSString *Cancel_Url = self.orderType == QGOrderType ? [self.baseUrl stringByAppendingString:@"qgorder/Delete.php"] : [self.baseUrl stringByAppendingString:@"order/Delete.php"];
    
    NSArray *arr = @[kHDUserId,self.orderID];
    
    [self showHud];
    [self.netWork asyncAFNPOST:Cancel_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"取消订单成功" Delegate:self];
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
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}

#pragma mark - 弹出支付框
- (void)payClick
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _maskView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - IS_HOTSPOT_HEIGHT);
    }];
}

#pragma mark - 微信支付
- (void)orderScreenWXPayWithUrl:(NSString *)url orderStr:(NSString *)orderStr {
    
    /** hud */
    MBProgressHUD *hud = [MBProgressHUD instanceHudInView:self.view Text:@"请稍等..." Mode:0 Delegate:nil];
    
    NSArray *array = @[kHDUserId,orderStr];
    
    [self.netWork asyncAFNPOST:url Param:array Success:^(id responseObjc, NSError *codeErr) {
        
        if (codeErr) {
            
            [hud hide:YES];
            
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
                
            } else if (code == 41 || code == 42 || code == 43) {
                
                switch (code) {
                        
                        case 41:
                        
                        [MBProgressHUD alertHUDInView:self.view Text:@"商品价格发生变更，该订单已失效"];
                        break;
                        
                        case 42:
                        
                        [MBProgressHUD alertHUDInView:self.view Text:@"订单未绑定收货地址"];
                        break;
                        
                        case 43:
                        
                        [MBProgressHUD alertHUDInView:self.view Text:@"请选择物流方式"];
                        break;
                        
                    default:
                        break;
                        
                }
                
            } else {
                
                [MBProgressHUD alertHUDInView:self.view Text:kServerError];
                
            }
            
        } else {
            
            NSDictionary *paramDic = @{kWXTimesTamp:responseObjc[@"timestamp"],
                                       kWXPID:responseObjc[@"pid"],
                                       kWXNonceStr:responseObjc[@"nonce_str"]};
            
            [hud hide:YES];
            
            [DDQWXPay WXPayParam:paramDic Result:^(NSError *WXError) {
                
                if (WXError) {
                    
                    [MBProgressHUD alertHUDInView:self.view Text:WXError.domain];
                    
                }
                
            }];
            
            //WX在AppDelegate中代理的回调
            [[NSNotificationCenter defaultCenter] addObserverForName:@"WX" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                
                PayResp *resp = note.object;
                if (resp.errCode == 0) {
                    
                    [MBProgressHUD alertHUDInView:self.view Text:@"支付成功" Delegate:self];
                    
                } else {
                    
                    if ([resp.errStr isEqualToString:@""] || resp.errStr == nil) {//判断微信的提示字符串是否为空
                        
                        [MBProgressHUD alertHUDInView:self.view Text:@"请稍后再试！"];
                        
                    } else {
                        
                        [MBProgressHUD alertHUDInView:self.view Text:resp.errStr];
                        
                    }
                    
                }
                
            }];
            
        }
        
    } Failure:^(NSError *netErr) {
        
        [hud hide:YES];
        
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
        
    }];
    
}

#pragma mark - 支付宝支付
- (void)requestAliPayUrl:(NSString *)url
{
    NSArray *arr = @[kHDUserId,self.orderID];
    [self showHud];
    [self.netWork asyncAFNPOST:url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            NSString *appScheme = @"CarAutoRepairBuy";
            
            //如果是唤起的网页版，则AL结果回调走这
            [[AlipaySDK defaultService] payOrder:responseObjc fromScheme:appScheme callback:^(NSDictionary *resultDic)
             {
                 NSLog(@"%@",responseObjc);
                 
                 if ([[resultDic valueForKey:@"resultStatus"] intValue] == 9000)
                 {
                     
                     [MBProgressHUD alertHUDInView:self.view Text:@"支付成功" Delegate:self];
                 }
                 else if([[resultDic valueForKey:@"resultStatus"] intValue] == 6001)
                 {
                     [MBProgressHUD alertHUDInView:self.view Text:@"您取消了本次支付"];
                 }
                 
             }];
            
            //客户端回调
            [[NSNotificationCenter defaultCenter] addObserverForName:@"AL" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note)
             {
                 
                 NSDictionary *resultDic = note.object;
                 
                 if ([[resultDic valueForKey:@"resultStatus"] intValue] == 9000)
                 {
                     
                     [MBProgressHUD alertHUDInView:self.view Text:@"支付成功" Delegate:self];
                     
                 }
                 else if([[resultDic valueForKey:@"resultStatus"] intValue] == 6001)
                 {
                     
                     [MBProgressHUD alertHUDInView:self.view Text:@"您取消了本次支付"];
                 }
                 else
                 {
                     [MBProgressHUD alertHUDInView:self.view Text:@"支付失败"];
                     
                     
                 }
                 
             }];
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
        else if (code == 29)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"该订单号不合法"];
        }
        else if (code == 30)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"订单不存在"];
        }
        else if (code == 37)
        {
            ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"请先添加收货地址"];
            [alert addBtnTitle:@"确定" action:^{
                [self clickAddressView];
            }];
            [alert showAlertWithSender:self];
        }
        else if (code == 39)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"余额支付失败，请重试"];
        }
        else if (code == 40)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"钱包余额不足"];
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

#pragma mark - 余额支付
- (void)requestBalancePay
{
    NSString *Balance_Url = self.orderType == GoodsOrderType ? [self.baseUrl stringByAppendingString:@"order/YePay.php"] : [self.baseUrl stringByAppendingString:@"qgorder/YePay.php"];
    
    NSArray *arr = @[kHDUserId,self.orderID];
    [self showHud];
    [self.netWork asyncAFNPOST:Balance_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"支付成功" Delegate:self];
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
        else if (code == 29)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"该订单号不合法"];
        }
        else if (code == 30)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"订单不存在"];
        }
        else if (code == 37)
        {
            ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"请先添加收货地址"];
            [alert addBtnTitle:@"确定" action:^{
                [self clickAddressView];
            }];
            [alert showAlertWithSender:self];
        }
        else if (code == 39)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"余额支付失败，请重试"];
        }
        else if (code == 38 || code == 40)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"钱包余额不足，请换其他支付方式"];
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

#pragma mark - 关闭蒙版
- (void)closeMaskView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _maskView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}

#pragma mark - 底部算总价
- (void)countPrice
{
    CGFloat totalPeice = 0;
    for (CROrderDetailModel *model in self.dataArr)
    {
        CGFloat price = [model.money floatValue];
        CGFloat amount = [model.amount floatValue];
        
        CGFloat tempPrice = price * amount;
        totalPeice += tempPrice;
    }
    NSString *totalPriceStr = [NSString stringWithFormat:@"%.2f",totalPeice];
    _totalPriceLabel.text = [NSString stringWithFormat:@"￥%@",totalPriceStr];;
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
