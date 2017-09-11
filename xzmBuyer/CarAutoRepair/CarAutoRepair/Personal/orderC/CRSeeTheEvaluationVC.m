//
//  CRSeeTheEvaluationVC.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/21.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRSeeTheEvaluationVC.h"
#import "CRSeeEvaluationCell.h"
#import "CRSeeEvaluationModel.h"

@interface CRSeeTheEvaluationVC ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic ,strong) UITableView *tableView;
/** 数据 */
@property (nonatomic ,strong) NSMutableArray *dataArr;
/** 页数 */
@property (nonatomic ,assign) NSInteger page;
/** 存放cell高度 */
@property(strong, nonatomic) NSMutableDictionary *heights;

@end

@implementation CRSeeTheEvaluationVC

static NSString *evaluationCell = @"cell";

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 32) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:@"CRSeeEvaluationCell" bundle:nil] forCellReuseIdentifier:evaluationCell];
    }
    return _tableView;
}

- (NSMutableDictionary *)heights
{
    if (!_heights)
    {
        _heights = [NSMutableDictionary dictionary];
    }
    return _heights;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    self.dataArr = [NSMutableArray arrayWithCapacity:1];
    
    _page = 1;
    
    [self requestDataPage:@(_page).stringValue];
    
    [self refreshTableView];
 
}

- (void)setupNav
{
    self.controllerName = @"所有评价";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - 全部评价数据
- (void)requestDataPage:(NSString *)page
{
    NSString *Check_Url = [self.baseUrl stringByAppendingString:@"user/PinjiaList.php"];
    NSArray *arr = @[kHDUserId,self.goodID,page];
    [self showHud];
    [self.netWork asyncAFNPOST:Check_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!codeErr)
        {
            for (NSDictionary *dic in responseObjc[@"pinjia"])
            {
                CRSeeEvaluationModel *model = [CRSeeEvaluationModel mj_objectWithKeyValues:dic];
                
                [self.dataArr addObject:model];
            }
            [self.view addSubview:self.tableView];
            
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
        else if (code == 67)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"该商品暂无评价"];
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

#pragma mark - 上下拉刷新
- (void)refreshTableView
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        [self.dataArr removeAllObjects];
        [self requestDataPage:@(self.page).stringValue];
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page++;
        
        [self requestDataPage:@(self.page).stringValue];
        
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - BarButtonItemAction
- (void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CRSeeEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:evaluationCell];
    
    if (indexPath.row < self.dataArr.count)
    {
        CRSeeEvaluationModel *model = self.dataArr[indexPath.row];
        
        cell.model = model;
    }
    
    [cell layoutIfNeeded];
    
    self.heights[@(indexPath.row)] = @(cell.height);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return [self.heights[@(indexPath.row)] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
