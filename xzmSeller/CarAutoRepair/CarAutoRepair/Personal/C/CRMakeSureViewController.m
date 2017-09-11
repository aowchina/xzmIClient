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
#import "CRAddressViewController.h"
#import "KTPayBottomView.h"

@interface CRMakeSureViewController ()<UITableViewDelegate,UITableViewDataSource>
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
/** 立即支付按钮 */
@property (nonatomic ,strong) UIButton *payBtn;
/** 蒙版 */
@property (nonatomic ,strong) UIView *maskView;
/** 底部支付view */
@property (nonatomic ,strong) KTPayBottomView *payView;

@end

@implementation CRMakeSureViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    [self creatBottomView];
    
    [self creatTableView];
 
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

#pragma markr - 底部支付view
- (void)creatPayBottomView
{
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
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
    __weak typeof(self)wself = self;
    _payView.cancelPayBlock = ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [wself closeMaskView];
        }];
    };
    
    // 支付宝支付
    _payView.aliPayActionBlock = ^{
        
        NSLog(@"支付宝");
    };
    
    // 微信支付
    _payView.weChatPayActionBlock = ^{
        
        NSLog(@"微信");
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
    
    CRMakeSureHeaderView *headerView = [[CRMakeSureHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAddressView)];
    
    [tapGesture setNumberOfTapsRequired:1];
    
    [headerView addGestureRecognizer:tapGesture];
    
    _tableView.tableHeaderView = headerView;

    [self.view addSubview:_tableView];
}

- (void)clickAddressView
{
    CRAddressViewController *addressListC = [[CRAddressViewController alloc] init];
    
    addressListC.makeSureType = 1;
    
    addressListC.addressSetSuccess = ^() {
        
        
    };
    
    [self.navigationController pushViewController:addressListC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return self.dataArr.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CROrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
    
    return cell;
}

#pragma mark - tableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    customView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = ColorForRGB(0x828282);
    label.text = @"商品详情";
    label.font = [UIFont systemFontOfSize:14];
    [customView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(customView.mas_left).offset(30);
        make.top.mas_equalTo(10);
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
    return 35;
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
    _numberLabel.text = @"订单号";
    [footerView addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
    }];
    
    _timelabel = [[UILabel alloc] init];
    _timelabel.font = [UIFont systemFontOfSize:13];
    _timelabel.text = @"下单时间";
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
    lab.font = [UIFont systemFontOfSize:16];
    [bottomView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(bottomView.mas_left).offset(15);
        make.bottom.mas_equalTo(bottomView.mas_bottom).offset(-15);
    }];
    
    _totalPriceLabel = [[UILabel alloc] init];
    _totalPriceLabel.textColor = kColor(199, 0, 0);
    _totalPriceLabel.text = @"¥152.00";
    _totalPriceLabel.font = [UIFont systemFontOfSize:17];
    [bottomView addSubview:_totalPriceLabel];
    [_totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(lab.mas_right).offset(11);
        make.bottom.mas_equalTo(bottomView.mas_bottom).offset(-15);
    }];
    
    UILabel *labe = [[UILabel alloc] init];
    labe.textColor = ColorForRGB(0x828282);
    labe.font = [UIFont systemFontOfSize:12];
    labe.text = @"(不含运费)";
    [bottomView addSubview:labe];
    [labe mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_totalPriceLabel.mas_right).offset(8);
        make.bottom.mas_equalTo(bottomView.mas_bottom).offset(-17);
    }];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payBtn setBackgroundColor:kColor(199, 0, 0)];
    [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_payBtn];
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(bottomView.mas_right);
        make.width.mas_equalTo(kScreenWidth / 3);
        make.bottom.mas_equalTo(bottomView.mas_bottom);
        make.top.mas_equalTo(bottomView.mas_top);
    }];
}

#pragma mark - 弹出立即支付
- (void)payClick
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _maskView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}

#pragma mark - 关闭蒙版
- (void)closeMaskView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _maskView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}



@end
