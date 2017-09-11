//
//  CRMyBillViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRMyBillViewController.h"
#import "CRMyBillTableViewCell.h"
#import "CRBillModel.h"

@interface CRMyBillViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
/** 数据 */
@property (nonatomic ,strong) NSMutableArray *dataArr;
/** 页数 */
@property (nonatomic ,assign) NSInteger page;

@end

@implementation CRMyBillViewController

static NSString * const idenyifier = @"mybillCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    
    _page = 1;
    
    self.dataArr = [NSMutableArray arrayWithCapacity:1];                                                                                         
    
    [self requeatCancelDataPage:@(_page).stringValue];
    
    [self createTableView];
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"我的账单";
    
    /** 右按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)requeatCancelDataPage:(NSString *)page
{
    NSArray *arr = @[kHDUserId,page];
    NSString *collectList_Url  = [self.baseUrl stringByAppendingString:@"user/wRecord.php"];
    [self showHud];
    
    [self.netWork asyncAFNPOST:collectList_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        if (!codeErr) {
            for (NSDictionary *dic in responseObjc[@"list"])
            {
                CRBillModel *model = [CRBillModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
            
        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                //跳转登录
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


/** 创建表格 */
- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 32)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];

    /** 去tableview的线 */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CRMyBillTableViewCell" bundle:nil] forCellReuseIdentifier:idenyifier];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        [self.dataArr removeAllObjects];
        [self requeatCancelDataPage:@(self.page).stringValue];
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page++; 
        
        [self requeatCancelDataPage:@(self.page).stringValue];
        
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRMyBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenyifier forIndexPath:indexPath];
    
    if (indexPath.row < self.dataArr.count)
    {
        CRBillModel *model = self.dataArr[indexPath.row];
        
        cell.model = model;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 69;
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
