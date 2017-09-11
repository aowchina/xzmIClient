//
//  CRAccOfferViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/15.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAccOfferViewController.h"
#import "CRProDeatilController.h"
#import "CRShopMarketCell.h"
#import "CRShopMarket.h"
#import "CRAccessoriesSubmmitController.h"
#import "CRAccessoriesOfferController.h"

@interface CRAccOfferViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation CRAccOfferViewController

static NSString * const idenyifier = @"shopMarketCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    [self setNav];
    
    self.pageNum = 1;
    
    [self createTableView];
    
    [self requestDataWithPage:self.pageNum];
    
}

- (void)requestDataWithPage:(NSInteger)pageNum {
    
    NSString *carSerialUrl = [BaseURL stringByAppendingString:@"goods/SetMoneyList.php"];
    
    [self showHud];
    
    [self.netWork asyncAFNPOST:carSerialUrl Param:@[kHDUserId,@(pageNum).stringValue,self.bid] Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            NSLog(@"%@",responseObjc);
            
            NSArray *array = responseObjc[@"setMoneyList"];
            
            for (NSDictionary *dic in responseObjc[@"setMoneyList"]) {
                
                CRShopMarket *model = [CRShopMarket mj_objectWithKeyValues:dic];
                
                [self.dataSource addObject:model];
            }
            
            [self.tableView reloadData];
            
            if (array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            
        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                /** 跳转登录 */
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
            } else {
                [MBProgressHUD buildHudWithtitle:@"服务器繁忙，请稍后重试!" superView:self.view];
            }
        }
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD buildHudWithtitle:@"无法连接到网络，请稍后再试!" superView:self.view];
    }];
    
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"报价者列表";
    /** 右按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
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
        
        self.pageNum = 1;
        
        self.dataSource = [NSMutableArray array];
        
        [self requestDataWithPage:self.pageNum];
        
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        
        [self requestDataWithPage:self.pageNum];
        
    }];
    
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRShopMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:idenyifier forIndexPath:indexPath];
    
    if (self.dataSource.count > indexPath.row) {
        
        CRShopMarket *model = self.dataSource[indexPath.row];
        
        [cell reloadDataWithModel:model andTypeStr:@"offerBuy"];
    }
    
    //    cell.offerBlock = ^(CRShopMarketCell *cellShop) {
    //
    //        NSIndexPath *indexPath1 = [self.tableView indexPathForCell:cellShop];
    //        CRShopMarket *model1 = self.dataSource[indexPath1.row];
    //
    //        CRAccessoriesOfferController *offerC = [[CRAccessoriesOfferController alloc] init];
    //
    //        offerC.shopModel = model1;
    //        offerC.hidesBottomBarWhenPushed = YES;
    //
    //        [self.navigationController pushViewController:offerC animated:YES];
    //    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenHeight * 0.20;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRShopMarket *model = self.dataSource[indexPath.row];
    
    CRAccessoriesOfferController *offerC = [[CRAccessoriesOfferController alloc] init];
    
    offerC.shopModel = model;
    offerC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:offerC animated:YES];
    
}


- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
