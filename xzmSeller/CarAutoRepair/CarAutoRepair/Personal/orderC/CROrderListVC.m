//
//  CROrderListVC.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CROrderListVC.h"
#import "CROrderListCell.h"
#import "CROrderListModel.h"
#import "CROrderDetailViewController.h"
#import "CRMakeSureViewController.h"

@interface CROrderListVC ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
/** 顶部view */
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 待付款按钮 */
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
/** 待发货按钮 */
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
/** 待收货按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
/** 待评价按钮 */
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
/** 全部按钮 */
@property (weak, nonatomic) IBOutlet UIButton *evalBtn;
/** 按钮宽 */
@property (nonatomic ,assign) CGFloat titleBtnWidth;

@property (nonatomic, strong) UIButton *selectBtn;
/** 红线 */
@property (nonatomic ,strong) UILabel *redLine;
/** 滑动背景 */
@property (strong, nonatomic) UIScrollView *bgScrollView;
/** 订单列表 */
// 全部 待付款 待发货 待发货 待评价
@property (strong, nonatomic) UITableView *tableView;
/** 分组数据 */
@property (nonatomic ,strong) NSMutableArray *sectionArr;
/** 列表数据 */
@property (nonatomic ,strong) NSMutableArray *listDataArr;
/** 分区2数据 */
@property (nonatomic ,strong) NSMutableArray *listSecArr;

/** 页数 */
@property (nonatomic ,assign) NSInteger page;

@end

@implementation CROrderListVC

static NSString *OrderListCell = @"cell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.page = 1;
    
    self.listDataArr = [NSMutableArray array];
    self.listSecArr = [NSMutableArray array];
    
    self.sectionArr = [NSMutableArray arrayWithArray:@[@"商品订单",@"求购订单"]];
    
    UIButton *btn = _topView.subviews[_btn_type];
    
    [self topBtnClick:btn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.page = 1;
    
    [self setupNav];
    // 顶部按钮
    [_allBtn setTitleColor:kColor(199, 0, 0) forState:UIControlStateSelected];
    [_payBtn setTitleColor:kColor(199, 0, 0) forState:UIControlStateSelected];
    [_sendBtn setTitleColor:kColor(199, 0, 0) forState:UIControlStateSelected];
    [_saveBtn setTitleColor:kColor(199, 0, 0) forState:UIControlStateSelected];
    [_evalBtn setTitleColor:kColor(199, 0, 0) forState:UIControlStateSelected];
    // 按钮宽
    _titleBtnWidth = kScreenWidth / 5;
    
    // 红线
    _redLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, _titleBtnWidth, 2)];
    _redLine.backgroundColor = kColor(199, 0, 0);
    [_topView addSubview:_redLine];
    // 背景
    self.bgScrollView.delegate = self;
    self.bgScrollView.pagingEnabled = YES;
    self.bgScrollView.bounces = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.bgScrollView setContentSize:CGSizeMake(kScreenWidth *5, 0)];
    
    [self buildScrollView];

    [self creatTableView];
  
}

- (void)buildScrollView {
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 110, kScreenWidth, kScreenHeight - 110)];
    self.bgScrollView.pagingEnabled = YES;
    self.bgScrollView.delegate = self;
    self.bgScrollView.pagingEnabled = YES;
    //    scrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.contentSize = CGSizeMake(kScreenWidth * 5, kScreenHeight - 110);
    [self.view addSubview:self.bgScrollView];
    
}


- (void)setupNav
{
    self.controllerName = @"我的订单";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

#pragma mark - BarButtonItemAction
- (void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据
- (void)requestDataPageNum:(NSString *)page
{
    
    NSString *OrderList_Url = [self.baseUrl stringByAppendingString:@"order/List.php"];
    
    NSArray *arr = @[kHDUserId,@(self.btn_type).stringValue,page];
    [self showHud];
    [self.netWork asyncAFNPOST:OrderList_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            for (NSDictionary *dic in responseObjc[@"shop"])
            {
                CROrderListModel *model = [CROrderListModel mj_objectWithKeyValues:dic];
                
                model.orderType = 1;
                
                [self.listDataArr addObject:model];
            }
            
            for (NSDictionary *dic in responseObjc[@"qiugou"])
            {
                CROrderListModel *model = [CROrderListModel mj_objectWithKeyValues:dic];
                
                model.orderType = 0;
                
                [self.listSecArr addObject:model];
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
        else if (code == 23)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"帮助中心暂时没有数据"];
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

#pragma mark - 按钮点击
- (IBAction)topBtnClick:(UIButton *)btn
{
    self.selectBtn.selected = NO;
    
    btn.selected = YES;
    
    self.selectBtn = btn;
    
    NSInteger index = btn.tag;

    _btn_type = index;
    
    [UIView animateWithDuration:0.2 animations:^{
        _redLine.frame = CGRectMake((btn.tag - 0) * kScreenWidth / 5, 36, _titleBtnWidth, 2);
    }];
    
    //滑动滚动
    [UIView animateWithDuration:0.2 animations:^{
        
        CGFloat offsetX = _bgScrollView.frame.size.width * index;
        
        [_bgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }];
    
    self.listDataArr = [NSMutableArray array];
    self.listSecArr = [NSMutableArray array];
    
    self.page = 1;
    
    [self requestDataPageNum:@(self.page).stringValue];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _bgScrollView)
    {
        NSInteger index = _bgScrollView.contentOffset.x / _bgScrollView.width;
        
        UIButton *btn = _topView.subviews[index];
        
        [self setTableViewFrame];
        
        [self topBtnClick:btn];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == _bgScrollView)
    {
        [self setTableViewFrame];
    }
}

- (void)setTableViewFrame
{
    NSInteger index = _bgScrollView.contentOffset.x / _bgScrollView.width;
    
    [UIView animateWithDuration:0 animations:^{
        self.tableView.frame = CGRectMake(index * kScreenWidth, 0, kScreenWidth, _bgScrollView.height);
    }];
}

#pragma mark - 加载列表
- (void)creatTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 101) style:UITableViewStylePlain];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [_bgScrollView addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CROrderListCell" bundle:nil] forCellReuseIdentifier:OrderListCell];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        [self.listDataArr removeAllObjects];
        [self.listSecArr removeAllObjects];
        [self requestDataPageNum:@(self.page).stringValue];
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page++;
        
        [self requestDataPageNum:@(self.page).stringValue];
        
         [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? self.listDataArr.count : self.listSecArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CROrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderListCell forIndexPath:indexPath];

    
    switch (indexPath.section) {
        case 0: {
            
            if (indexPath.row < self.listDataArr.count)
            {
                CROrderListModel *model = self.listDataArr[indexPath.row];
                
                [cell reloadCell:model Type:self.btn_type and:0];
            }
        }
            break;
        case 1: {
            
            if (indexPath.row < self.listSecArr.count)
            {
                CROrderListModel *model = self.listSecArr[indexPath.row];
                
                [cell reloadCell:model Type:self.btn_type and:1];
            }
        }
            break;
            
        default:
            break;
    }
     
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CROrderListModel *model;
    
    switch (indexPath.section) {
        case 0: {

            model = self.listDataArr[indexPath.row];

        }
            break;
        case 1: {
            
            model = self.listSecArr[indexPath.row];
        }
            break;
            
        default:
            break;
    }
    
    CROrderDetailViewController *orderDetailVC =  [[CROrderDetailViewController alloc] init];
    
    orderDetailVC.orderType = self.btn_type;
    
    orderDetailVC.orderID =  model.orderType == 1 ? model.orderid : model.qgorderid;

    orderDetailVC.qgType = model.orderType;
        // 跳订单详情
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    
}


@end
