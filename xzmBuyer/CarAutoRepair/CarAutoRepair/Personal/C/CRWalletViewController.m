//
//  CRWalletViewController.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/2.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRWalletViewController.h"
#import "CRWalletListCell.h"
#import "CRMyBillViewController.h"
#import "CRGetMoneyView.h"
#import "CRTixianModel.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"

@interface CRWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 可用余额 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
/** 微信提现按钮 */
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;
/** 支付宝提现按钮 */
@property (weak, nonatomic) IBOutlet UIButton *aliBtn;
/** 没有成交记录view */
@property (weak, nonatomic) IBOutlet UIImageView *noView;
/** 线 */
@property (weak, nonatomic) IBOutlet UILabel *line;
/** 列表 */
@property (nonatomic ,strong) UITableView *listTableView;
/** 数据 */
@property (nonatomic ,strong) NSMutableArray *dataArr;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic ,strong) CRGetMoneyView *getMoneyView;

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation CRWalletViewController

static NSString *listCell = @"cell";

- (NSMutableArray *)dataArr
{
    if (!_dataArr)
    {
        _dataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageNum = 1;
    
    _moneyLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [self setupNav];
    
    self.weChatBtn.selected = YES;
    
    [self creatTableView];
    [self requestData];
    
}

- (void)requestTixianData:(NSString *)page {
    
    NSString *Money_Url = [self.baseUrl stringByAppendingString:@"user/txRecord.php"];
    NSArray *arr = @[kHDUserId,page];
    [self showHud];
    [self.netWork asyncAFNPOST:Money_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            
            NSArray *array = responseObjc[@"list"];
            
            for (NSDictionary *dic in array) {
                
                CRTixianModel *model = [CRTixianModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            [self.listTableView reloadData];
            
            if (array.count == 0 ) {
                
                [self.listTableView.mj_footer endRefreshingWithNoMoreData];

                if (self.dataArr.count <= 0) {
                    
                    self.listTableView.hidden = YES;
                    self.backView.hidden = YES;
                }
 
            } else {
                
                [self.listTableView.mj_footer endRefreshing];
                self.listTableView.hidden = NO;
                self.backView.hidden = NO;
            }
        }
        else if (code == 12)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"用户未登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        } else {
            
            [self.listTableView.mj_footer endRefreshing];
            
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];

}

- (void)setupNav
{
    self.controllerName = @"我的钱包";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItem initWithTitle:@"账单" titleColor:ColorForRGB(0x828282) target:self action:@selector(rightBarButtonItemAction)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)rightBarButtonItemAction {
    
    // 我的账单
    CRMyBillViewController *myBillC = [[CRMyBillViewController alloc] init];

    [self.navigationController pushViewController:myBillC animated:YES];
    
}

#pragma mark - BarButtonItemAction
- (void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求钱包数据
- (void)requestData
{
    NSString *Money_Url = [self.baseUrl stringByAppendingString:@"user/wallet.php"];
    NSArray *arr = @[kHDUserId];
//    [self showHud];
    [self.netWork asyncAFNPOST:Money_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        
        [self requestTixianData:@(self.pageNum).stringValue];
        
//        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@",responseObjc[@"money"]];
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
//        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}

#pragma mark - 微信提现
- (IBAction)weChatWithdrawalAction:(UIButton *)sender
{
    self.weChatBtn.selected = YES;
    
    self.aliBtn.selected = NO;
}

#pragma mark - 支付宝提现
- (IBAction)AliWithdrawalAction:(id)sender
{
    self.aliBtn.selected = YES;
    
    self.weChatBtn.selected = NO;
}

#pragma mark - 提现按钮点击
- (IBAction)withdrawalBtnClick:(id)sender
{

    
    if (self.weChatBtn.selected == YES) {
        
//        if (![WXApi isWXAppInstalled])
//        {
            CRGetMoneyView *getMoneyView = [CRGetMoneyView viewFromXib];
            getMoneyView.frame = self.view.bounds;
            
            getMoneyView.tixianType = wechatType;
            
            [self.view addSubview:getMoneyView];
            
            getMoneyView.getMoneyBlock = ^(NSString *accountStr, NSString *moneyStr) {
                
                NSString *money = [NSString stringWithFormat:@"%.2f",[moneyStr floatValue]];
                
                [self tixianActionWithAccount:accountStr andMoney:money];
            };
            
//        }
//        else
//        {
//            //没有安装给个提示
//            [self setupAlertController];
//        }
        
    }
    
    if (self.aliBtn.selected == YES) {
        
        CRGetMoneyView *getMoneyView = [CRGetMoneyView viewFromXib];
        getMoneyView.frame = self.view.bounds;
        
        getMoneyView.tixianType = aliType;
        
        [self.view addSubview:getMoneyView];
        
        getMoneyView.getMoneyBlock = ^(NSString *accountStr, NSString *moneyStr) {
            
            NSString *money = [NSString stringWithFormat:@"%.2f",[moneyStr floatValue]];
            
            [self tixianActionWithAccount:accountStr andMoney:money];
            
        };
    }
}

/** tixian */
- (void)tixianActionWithAccount:(NSString *)account andMoney:(NSString *)money {
//    weixn
    if (self.weChatBtn.selected == YES) {
        
        if ([SuperHelper isEmpty:money] && money.floatValue <= 0) {
            
            [MBProgressHUD buildHudWithtitle:@"请输入需要提现的金额" superView:self.view];
            return;
        }

        [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            if (state == SSDKResponseStateSuccess) {

                NSArray *array = @[kHDUserId,money,user.uid];
                [self showHud];
                [self.netWork asyncAFNPOST:[BaseURL stringByAppendingString:@"user/txToWx.php"] Param:array Success:^(id responseObjc, NSError *codeErr) {
                    [self endHud];
                    
                    NSInteger code = codeErr.code;
                    
                    if (!code)
                    {
                        [MBProgressHUD alertHUDInView:self.view Text:@"提现成功"];
                        self.dataArr = [NSMutableArray array];
                        [self requestData];
//                        [self requestTixianData];
                    }
                    else if (code == 38 || code == 40)
                    {
                        [MBProgressHUD alertHUDInView:self.view Text:@"账户余额不足"];
                    }
                    else if (code == 43)
                    {
                        [MBProgressHUD alertHUDInView:self.view Text:@"该手机号对应多个支付宝账户，请传入收款方姓名确定正确的收款账号"];
                    }
                    else if (code == 44)
                    {
                        [MBProgressHUD alertHUDInView:self.view Text:@"单笔额度超限"];
                    }
                    else if (code == 45)
                    {
                        [MBProgressHUD alertHUDInView:self.view Text:@"收款账号不存在"];
                    }
                    
                    else if (code == 46)
                    {
                        [MBProgressHUD alertHUDInView:self.view Text:@"请用户支付宝站内或手机客户端补充身份信息"];
                    }
                    else if (code == 48)
                    {
                        [MBProgressHUD alertHUDInView:self.view Text:@"单笔提现达到5万"];
                    }
                    else if (code == 57)
                    {
                        [MBProgressHUD alertHUDInView:self.view Text:@"您的余额不足"];
                    }
                    else if (code == 58)
                    {
                        [MBProgressHUD alertHUDInView:self.view Text:@"暂时无法提现"];
                    }
                    else if (code == 55)
                    {
                        [MBProgressHUD alertHUDInView:self.view Text:@"提现金额需超过1元"];
                    }
                    else if (code == 63)
                    {
                        [MBProgressHUD alertHUDInView:self.view Text:@"提现失败，请再试一次"];
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
        }];
        
    }
    
    /** 支付宝提现 */
    if (self.aliBtn.selected == YES) {
        
        if ([SuperHelper isEmpty:account]) {
            
            [MBProgressHUD buildHudWithtitle:@"请输入需要提现的账号" superView:self.view];
            return;
        }
        
        if ([SuperHelper isEmpty:money] && money.floatValue <= 0) {
            
            [MBProgressHUD buildHudWithtitle:@"请输入需要提现的金额" superView:self.view];
            return;
        }
        
        NSArray *array = @[kHDUserId,money,account];
        [self showHud];
        [self.netWork asyncAFNPOST:[BaseURL stringByAppendingString:@"user/txToZfb.php"] Param:array Success:^(id responseObjc, NSError *codeErr) {
            [self endHud];
            NSLog(@"%@",responseObjc);
            
            NSInteger code = codeErr.code;
            
            if (!code)
            {
                [MBProgressHUD alertHUDInView:self.view Text:@"提现成功"];
                
                self.dataArr = [NSMutableArray array];
                [self requestData];
//                [self requestTixianData];
            }
            else if (code == 38 || code == 40)
            {
                [MBProgressHUD alertHUDInView:self.view Text:@"账户余额不足"];
            }
            else if (code == 43)
            {
                [MBProgressHUD alertHUDInView:self.view Text:@"该手机号对应多个支付宝账户，请传入收款方姓名确定正确的收款账号"];
            }
            else if (code == 44)
            {
                [MBProgressHUD alertHUDInView:self.view Text:@"单笔额度超限"];
            }
            else if (code == 45)
            {
                [MBProgressHUD alertHUDInView:self.view Text:@"收款账号不存在"];
            }

            else if (code == 46)
            {
                [MBProgressHUD alertHUDInView:self.view Text:@"请用户支付宝站内或手机客户端补充身份信息"];
            }
            else if (code == 48)
            {
                [MBProgressHUD alertHUDInView:self.view Text:@"单笔提现达到5万"];
            }
            else if (code == 68)
            {
                [MBProgressHUD alertHUDInView:self.view Text:@"暂时无法提现"];
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
    
}

- (void)creatTableView
{
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 332, kScreenWidth, kScreenHeight - 332) style:UITableViewStylePlain];
    
    _listTableView.delegate = self;
    
    _listTableView.dataSource = self;
    
    [_listTableView registerNib:[UINib nibWithNibName:@"CRWalletListCell" bundle:nil] forCellReuseIdentifier:listCell];
    
    [self.view addSubview:_listTableView];
    
    self.listTableView.hidden = YES;
    
    self.listTableView.tableFooterView = [[UIView alloc] init];
    
    self.listTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        
        [self requestTixianData:@(self.pageNum).stringValue];
        
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CRWalletListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
    
    cell.model = self.dataArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 没有安装微信
- (void)setupAlertController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
