//
//  CRMycollectionViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRMycollectionViewController.h"
#import "CRMycollectionCell.h"
#import "CRMyCollecModel.h"
#import "CRProDeatilController.h"

@interface CRMycollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
/** 数据 */
@property (nonatomic ,strong) NSMutableArray *dataArr;

@end

@implementation CRMycollectionViewController

static NSString * const identifier = @"mycollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self setNav];
    
    self.dataArr = [NSMutableArray array];
    
    [self requeatData];
    
    [self createTableView];
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"我的收藏";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - 收藏列表接口
- (void)requeatData
{
    NSArray *arr = @[kHDUserId];
    NSString *collectList_Url  = [self.baseUrl stringByAppendingString:@"user/collect.php"];
    [self showHud];
    
    [self.netWork asyncAFNPOST:collectList_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        if (!codeErr) {
            for (NSDictionary *dic in responseObjc[@"list"])
            {
                CRMyCollecModel *model = [CRMyCollecModel mj_objectWithKeyValues:dic];
                
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    /** 去tableview的线 */
    //  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CRMycollectionCell" bundle:nil] forCellReuseIdentifier:identifier];
}

#pragma mark - UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRMycollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    CRMyCollecModel *model = self.dataArr[indexPath.row];
    
    if (indexPath.row < self.dataArr.count)
    {
        cell.model = model;
    }
    
    cell.cancelBlock = ^{
        
        [self requeatCancelDataGoodID:model.goodid];
    };
    
    return cell;
}

#pragma mark - 取消收藏
- (void)requeatCancelDataGoodID:(NSString *)goodID
{
    NSArray *arr = @[kHDUserId,goodID];
    NSString *collectList_Url  = [self.baseUrl stringByAppendingString:@"user/DeleteCollect.php"];
    [self showHud];
    
    [self.netWork asyncAFNPOST:collectList_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        if (!codeErr) {
            
            [self.dataArr removeAllObjects];
            ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"取消成功"];
            [alert addBtnTitle:@"确定" action:^{
                [self requeatData];

            }];
            [alert showAlertWithSender:self];
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRProDeatilController *proDetailC = [[CRProDeatilController alloc] init];
    CRMyCollecModel *model = self.dataArr[indexPath.row];
    proDetailC.goodid = model.goodid;
    [self.navigationController pushViewController:proDetailC animated:YES];
    
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
