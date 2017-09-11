//
//  CRShopMarketController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/18.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRShopMarketController.h"
#import "CRShopMarketCell.h"
#import "DDQLoopView.h"
#import "CRProDeatilController.h"
#import "CRShopMarket.h"
#import "CRWebViewController.h"

#import "SDCycleScrollView.h"
#import "CRAccessoriesSearchController.h"


@interface CRShopMarketController () <UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic ,strong) NSMutableArray *imgArr;

/** 页数 */
@property (nonatomic ,assign) NSInteger page;

@property (nonatomic,strong) SDCycleScrollView *cycleScrollView2;/** 轮播图 */

@end

@implementation CRShopMarketController

static NSString * const idenyifier = @"shopMarketCell";

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    self.dataSource = [NSMutableArray array];
//    self.imgArr = [NSMutableArray array];
//    
//    self.page = 1;
//    
//    [self requestEpcDeatilDataPageNum:@(self.page).stringValue];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
//    [self buildLoopView];
    [self createTableView];
    [self buildLoopView];
    
    self.dataSource = [NSMutableArray array];
    self.imgArr = [NSMutableArray array];
    
    self.page = 1;
    
    [self requestEpcDeatilDataPageNum:@(self.page).stringValue];
}

- (void)buildLoopView {
    
    /*
    self.loopScrollView = [[DDQLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.25)];
    self.loopScrollView.delegate = self;

    [self.loopScrollView.loop_collection reloadData];

     */
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.25) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    
    self.cycleScrollView2 = cycleScrollView2;
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"商城";
    
    /** 左按钮 */
    /*
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithTitle:@"筛选" titleColor:ColorForRGB(0x828282) target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
     */
    // 右按钮 
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_sousuo" target:self action:@selector(rightBarButtonItemAction) width:20 height:20];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

#pragma mark - 请求数据
- (void)requestEpcDeatilDataPageNum:(NSString *)page
{
    NSString *GoodsList_Url = [self.baseUrl stringByAppendingString:@"goods/List.php"];
    NSArray *arr = @[kHDUserId,page];
    [self showHud];
    [self.netWork asyncAFNPOST:GoodsList_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSInteger code = codeErr.code;


        NSLog(@"%@",responseObjc);
        
        if (!code)
        {
            for (NSDictionary *dic in responseObjc[@"goods"])
            {
                CRShopMarket *model = [CRShopMarket mj_objectWithKeyValues:dic];
                
                [self.dataSource addObject:model];
            }
            
            NSMutableArray *imageArray = [NSMutableArray array];
            
            for (NSDictionary *dic in responseObjc[@"ad"]) {
                
                CRShopMarket *adModel = [CRShopMarket mj_objectWithKeyValues:dic];
                
                [self.imgArr addObject:adModel];
                [imageArray addObject:adModel.img];
            }
            
            self.tableView.tableHeaderView = self.cycleScrollView2;

            self.cycleScrollView2.imageURLStringsGroup = imageArray;
            
            [self.tableView reloadData];
        }
        else if (code == 12)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"用户未登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else if (code == 22)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"此epc结构图详情暂未发布"];
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

/** 创建表格 */
- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = kColor(234, 234, 236);
    /** 去tableview的线 */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.tableHeaderView = self.loopScrollView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CRShopMarketCell" bundle:nil] forCellReuseIdentifier:idenyifier];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        
        self.dataSource = [NSMutableArray array];
        self.imgArr = [NSMutableArray array];
        
        [self requestEpcDeatilDataPageNum:@(self.page).stringValue];
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page++;
        
        [self requestEpcDeatilDataPageNum:@(self.page).stringValue];
        
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRShopMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:idenyifier forIndexPath:indexPath];
    
    if (indexPath.row < self.dataSource.count)
    {
        CRShopMarket *model = self.dataSource[indexPath.row];
        [cell reloadDataWithModel:model andTypeStr:@""];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenHeight * 0.20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CRShopMarket *model = self.dataSource[indexPath.row];
    CRProDeatilController *proDetailC = [[CRProDeatilController alloc] init];
    proDetailC.goodid = model.goodid;
    proDetailC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:proDetailC animated:YES];
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    CRShopMarket *model = self.imgArr[index];
    
    if ([model.gid isEqualToString:@"0"]) {
        
        CRWebViewController *webC = [[CRWebViewController alloc] init];
        webC.name = model.name;
        webC.url = model.url;
        webC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webC animated:YES];
        
    } else {
        
        CRProDeatilController *proDetailC = [[CRProDeatilController alloc] init];
        proDetailC.goodid = model.gid;
        proDetailC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:proDetailC animated:YES];
        
    }

}

#pragma mark - BtnAction -
- (void)leftBarButtonItemAction {
    
}

- (void)rightBarButtonItemAction {
    
    CRAccessoriesSearchController *accessoriesSC = [[CRAccessoriesSearchController alloc] init];
    accessoriesSC.pushType = AccessoriesViewControllerType;
    accessoriesSC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:accessoriesSC animated:YES];
    
}


@end
