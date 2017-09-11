//
//  CRAccessoriesListViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/3.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAccessoriesListViewController.h"
#import "CRAccessoriesListCell.h"
#import "TracyCarViewController.h"
#import "CRFriendListModel.h"

@interface CRAccessoriesListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation CRAccessoriesListViewController

static NSString * const identifirer = @"accessoriesListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];

    [self.tableView.mj_header beginRefreshing];
}

- (void)requestDataWithPage:(NSInteger)pageNum {
    
    NSString *carSerialUrl = [BaseURL stringByAppendingString:@"pjs/pjsList.php"];
    
    [self showHud];
    
    [self.netWork asyncAFNPOST:carSerialUrl Param:@[kHDUserId,@(pageNum).stringValue] Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            NSLog(@"%@",responseObjc);
            
            NSArray *array = responseObjc;
            
            for (NSDictionary *dic in responseObjc) {
                
                CRFriendListModel *model = [CRFriendListModel mj_objectWithKeyValues:dic];
                
                model.type = @"accessory";
                
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

- (void)createTableView {
    
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 41) style:UITableViewStylePlain];
    
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tabelView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tabelView];
    
    [tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([CRAccessoriesListCell class]) bundle:nil] forCellReuseIdentifier:identifirer];
    
    self.tableView = tabelView;
    
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
    
    CRAccessoriesListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifirer];
    
    if (self.dataSource.count > indexPath.row) {
        
        cell.model = self.dataSource[indexPath.row];
        
    }
    
    cell.addFriendBlock = ^(CRAccessoriesListCell *accCell) {
        
        NSIndexPath *index = [self.tableView indexPathForCell:accCell];
        
        CRFriendListModel *crModel = self.dataSource[index.row];
        
        [self addFriendWithID:crModel.sellerid];
        
    };
    
    return cell;
}

- (void)addFriendWithID:(NSString *)aID {
    
    NSString *carSerialUrl = [BaseURL stringByAppendingString:@"addfriend/add.php"];
    
    [self showHud];
    
    NSArray *array = @[kHDUserId,aID];
    
    [self.netWork asyncAFNPOST:carSerialUrl Param:array Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            [MBProgressHUD alertHUDInView:self.view Text:@"添加成功！"];
            
            self.dataSource = [NSMutableArray array];
            self.pageNum = 1;
            
            [self requestDataWithPage:self.pageNum];
            
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /** 聊天 */
    CRFriendListModel *model = self.dataSource[indexPath.row];

    TracyCarViewController *chatController = [[TracyCarViewController alloc] initWithConversationChatter:[@"sell" stringByAppendingString:model.sellerid] conversationType:EMConversationTypeChat];
    
    chatController.headUrl = model.picture;
    chatController.title = model.name;
    
    [self.navigationController pushViewController:chatController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}


@end
