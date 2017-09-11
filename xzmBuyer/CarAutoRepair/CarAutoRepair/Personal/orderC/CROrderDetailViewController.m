//
//  CROrderDetailViewController.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/5/31.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CROrderDetailViewController.h"
#import "CROrderDetailHeaderView.h"
#import "CROrderDetailBottomView.h"
#import "CROrderDetailCell.h"
#import "CROrderDetailModel.h"
#import "HDLogisticsViewController.h"
#import "CRMakeSureViewController.h"
#import "CRPublishedEvaluationVC.h"
#import "CRSeeTheEvaluationVC.h"

@interface CROrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
/** 列表 */
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) CROrderDetailHeaderView *headerView;

@property (nonatomic ,strong) CROrderDetailBottomView *bottomView;
/** 数据 */
@property (nonatomic ,strong) NSMutableArray *dataArr;
/** 商品ID */
@property (nonatomic ,strong) NSString *goodID;

@property (nonatomic, strong) NSString *wulName;
@property (nonatomic, strong) NSString *kuaidih;

@end

@implementation CROrderDetailViewController

static NSString *headerCell = @"header";
static NSString *listCell = @"cell";

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 49) style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [_tableView registerNib:[UINib nibWithNibName:@"CROrderDetailCell" bundle:nil] forCellReuseIdentifier:listCell];
    }
    return _tableView;
}

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
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupNav];
    
    [self requestData];

    self.headerView = [CROrderDetailHeaderView viewFromXib];
    
    CGFloat headerViewHeight;
    switch (self.orderType)
    {
        case 1:
            headerViewHeight = 170;
            break;
        case 2:
            headerViewHeight = 240;
            break;
        case 3:
            headerViewHeight = 265;
            break;
        case 4:
            headerViewHeight = 265;
            break;
            
        default:
            break;
    }
    
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, headerViewHeight);

    self.tableView.tableHeaderView = self.headerView;
    
    [self.view addSubview:self.tableView];
    
    [self setUpBottomView];
}

- (void)setupNav
{
    self.controllerName = @"订单详情";
    
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
    NSString *OrderDetail_Url = self.qgType == 0 ? [self.baseUrl stringByAppendingString:@"qgorder/Detail.php"] : [self.baseUrl stringByAppendingString:@"order/Detail.php"];
    
    NSArray *arr = @[kHDUserId,self.orderID];
    [self showHud];
    [self.netWork asyncAFNPOST:OrderDetail_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);

        NSInteger code = codeErr.code;
        
        if (!code)
        {
            // 姓名
            self.headerView.nameLabel.text = responseObjc[@"sname"];
            // 地址
            self.headerView.addressLabel.text = responseObjc[@"address"];
            // 订单编号
            self.headerView.orderNumLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.orderID];
            // 下单时间
            self.headerView.orderTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",responseObjc[@"addtime"]];
            // 支付时间
            self.headerView.payTimeLabel.text = [NSString stringWithFormat:@"支付时间：%@",responseObjc[@"paytime"]];
            if (self.orderType == 1)  // 待发货
            {
                self.headerView.wuLiuNumberLabel.hidden = YES;
                self.headerView.wuLiuNameLabel.hidden = YES;
                self.headerView.sendTimeLabel.hidden = YES;
                self.headerView.saveTimeLabel.hidden = YES;
            }
            // 待收货 | 待评价 | 已完成
            else if (self.orderType == 2)
            {
                self.headerView.wuLiuNameLabel.text = [NSString stringWithFormat:@"物流名称：%@",responseObjc[@"wlname"]];
                self.headerView.wuLiuNumberLabel.text = [NSString stringWithFormat:@"物流单号：%@",responseObjc[@"kuaidih"]];
                self.headerView.payTimeLabel.text = [NSString stringWithFormat:@"支付时间：%@",responseObjc[@"paytime"]];
                self.headerView.sendTimeLabel.text = [NSString stringWithFormat:@"发货时间：%@",responseObjc[@"fhtime"]];
                self.headerView.saveTimeLabel.hidden = YES;
                
            }
            else if (self.orderType == 3 || self.orderType == 4)
            {
                
                if (![responseObjc[@"fhtime"] isEqualToString:@" "]) {
                    
                    self.headerView.wuLiuNameLabel.text = [NSString stringWithFormat:@"物流名称：%@",responseObjc[@"wlname"]];
                    self.headerView.wuLiuNumberLabel.text = [NSString stringWithFormat:@"物流单号：%@",responseObjc[@"kuaidih"]];
                    self.headerView.payTimeLabel.text = [NSString stringWithFormat:@"支付时间：%@",responseObjc[@"paytime"]];
                    self.headerView.sendTimeLabel.text = [NSString stringWithFormat:@"发货时间：%@",responseObjc[@"fhtime"]];
                    self.headerView.saveTimeLabel.text = [NSString stringWithFormat:@"收货时间：%@",responseObjc[@"retime"]];
                    
                } else {
                    
                    self.headerView.wuLiuNameLabel.hidden = YES;
                    self.headerView.wuLiuNumberLabel.hidden = YES;
                    self.headerView.sendTimeLabel.hidden = YES;
                    self.headerView.saveTimeLabel.hidden = YES;

                    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 170);
                    
                    self.tableView.tableHeaderView = self.headerView;
                }
            }
            
            for (NSDictionary *dic in responseObjc[@"goods"])
            {
                CROrderDetailModel *model = [CROrderDetailModel mj_objectWithKeyValues:dic];
                
                model.orderType = self.qgType;
                
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
            
            if (self.qgType == QGOrderType) {
                
                NSString *totalPriceStr = [NSString stringWithFormat:@"%.2f",[responseObjc[@"total_money"] floatValue]];
                self.bottomView.totalPrice.text = [NSString stringWithFormat:@"￥%@",totalPriceStr];
            } else {
                [self countPrice];
            }
            
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
        else if (code == 30)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"订单不存在或是已取消"];
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
    self.bottomView.totalPrice.text = [NSString stringWithFormat:@"￥%@",totalPriceStr];;
}

#pragma mark - 底部
- (void)setUpBottomView
{
    self.bottomView = [[CROrderDetailBottomView alloc] init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(49);
    }];
    
    __weak typeof(self)wself = self;
    switch (self.orderType)
    {
        case 1:
        {
            self.bottomView.cancelBtn.hidden = YES;
            [self.bottomView.payBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            self.bottomView.payBlock = ^{
                
                ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"是否要取消该订单？"];
                [alert addBtnTitle:@"取消" action:^{
                    
                    
                }];
                [alert addBtnTitle:@"确定" action:^{
                    
                    [wself cancelClick];
                }];
                [alert showAlertWithSender:wself];
            };
        }
            break;
        case 2:
        {
            [self.bottomView.cancelBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [self.bottomView.payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            self.bottomView.cancelBlock = ^{
                
                HDLogisticsViewController *logisticsVC = [[HDLogisticsViewController alloc] init];
                logisticsVC.order_id = wself.orderID;
                logisticsVC.orderType = wself.qgType;
                logisticsVC.wuliuType = wself.headerView.wuLiuNameLabel.text;
                logisticsVC.yundanNum = wself.headerView.wuLiuNumberLabel.text;
                [wself.navigationController pushViewController:logisticsVC animated:YES];
            };
            
            self.bottomView.payBlock = ^{
                
                ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"确认已收到包裹？"];
                [alert addBtnTitle:@"取消" action:^{
                    
                    
                }];
                [alert addBtnTitle:@"确定" action:^{
                    
                    [wself sureSaveClick];
                }];
                [alert showAlertWithSender:wself];
            };
        }
            break;
        case 3:
        {
            self.bottomView.cancelBtn.hidden = YES;
            [self.bottomView.payBtn setTitle:@"去评价" forState:UIControlStateNormal];
            self.bottomView.payBlock = ^{
                
                CRPublishedEvaluationVC *publishedEvaluationVC = [[CRPublishedEvaluationVC alloc] init];
                publishedEvaluationVC.goodID = wself.goodID;
                publishedEvaluationVC.orderID = wself.orderID;
                [wself.navigationController pushViewController:publishedEvaluationVC animated:YES];
            };
        }
            break;
        case 4:
        {
            self.bottomView.cancelBtn.hidden = YES;
            
            self.bottomView.payBtn.hidden = self.qgType == QGOrderType ? YES : NO;
            
            [self.bottomView.payBtn setTitle:@"查看评价" forState:UIControlStateNormal];
            self.bottomView.payBlock = ^{
                
                CRSeeTheEvaluationVC *seeEvaluationVC = [[CRSeeTheEvaluationVC alloc] init];
                seeEvaluationVC.goodID = wself.goodID;
                [wself.navigationController pushViewController:seeEvaluationVC animated:YES];
            };
        }
            break;
            
        default:
            break;
    }
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
        self.goodID = model.goodid;
    }
    
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 取消订单
- (void)cancelClick
{
    NSString *Cancel_Url = self.qgType == 0 ? [self.baseUrl stringByAppendingString:@"qgorder/Delete.php"] : [self.baseUrl stringByAppendingString:@"order/Delete.php"];
    
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

#pragma mark - 确认收货
- (void)sureSaveClick
{
    NSString *Cancel_Url = self.qgType == 1 ? [self.baseUrl stringByAppendingString:@"order/GetGoods.php"] : [self.baseUrl stringByAppendingString:@"qgorder/GetGoods.php"];
    NSArray *arr = @[kHDUserId,self.orderID];
    [self showHud];
    [self.netWork asyncAFNPOST:Cancel_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"确认收货成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
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
        else if (code  == 30)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"订单不存在或是已取消"];
        }
        else if (code == 35)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"此商品不存在"];
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
