//
//  CRGoodesManageController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/5.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRGoodesManageController.h"
#import "CRGoodsManageCell.h"
#import "CRSalePeijianController.h"
#import "GoodManageModel.h"
#import "CRProDeatilController.h"
#import "CRSalePeijianController.h"

@interface CRGoodesManageController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MBProgressHUDDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *tempBtn;

@property (nonatomic, strong) UIView *underLineV;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, assign) NSInteger btn_type;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation CRGoodesManageController

static NSString * const identifier = @"goodsManageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pageNum = 1;
    
    [self setNav];
    [self buildTitleView];
    [self buildScrollView];
    [self createTableView];
//    [self createBottomView];
}

- (void)requestDataWithPage:(NSString *)page {
    
    NSString *stateType;
    
    if (self.btn_type == 0) {
        stateType = @"1";
    } else if (self.btn_type == 1) {
        stateType = @"3";
    } else if (self.btn_type == 2) {
        stateType = @"2";
    } else if (self.btn_type == 3) {
        stateType = @"0";
    }
    
    NSString *goodListUrl = [BaseURL stringByAppendingString:@"goods/List.php"];
    NSLog(@"%@",kHDUserId);
    [self showHud];
    
    [self.netWork asyncAFNPOST:goodListUrl Param:@[kHDUserId,stateType,page] Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            NSLog(@"%@",responseObjc);
            
            NSArray *array = responseObjc[@"goods"];
            
            for (NSDictionary *dic in array) {
                
                GoodManageModel *model = [GoodManageModel mj_objectWithKeyValues:dic];
                
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
                //跳转登录
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
            } else if (code == 56) {
              
                
            } else {
                [MBProgressHUD buildHudWithtitle:@"服务器繁忙，请稍后重试!" superView:self.view];
            }
        }
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD buildHudWithtitle:@"无法连接到网络，请稍后再试!" superView:self.view];
    }];
}

- (void)buildTitleView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 30)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    self.headView = view;
    /** 线 */
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30 + 64, kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    NSArray *array = @[@"出售中",@"已下架",@"审核中",@"审核不通过"];
    CGFloat btn_width = kScreenWidth / array.count;
    CGFloat btn_height = view.height - 1;
    
    /** 创建按钮 */
    for (int i = 0; i < array.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(btn_width * i, 0, btn_width, btn_height);
        btn.titleLabel.font = KFont(13);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setTitleColor:ColorForRGB(0x828282) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    UIButton *firstbtn = view.subviews.firstObject;
    
    [self clickTitleBtn:firstbtn];
    
    [firstbtn.titleLabel sizeToFit];
    
    /** 底部红线 */
    UIView *underLineV = [UIView new];
    underLineV.backgroundColor = ColorForRGB(0xc80000);
    [view addSubview:underLineV];
    [underLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(firstbtn.mas_centerX);
        make.width.offset(kScreenWidth / 4);
        make.height.offset(1);
        make.top.offset(view.height - 1);
    }];
    self.underLineV = underLineV;
}

- (void)buildScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 31, kScreenWidth, kScreenHeight - 64 - 31 - 40)];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    //    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(kScreenWidth * 4, kScreenHeight - 64 - 31 - 40);
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
}

- (void)clickTitleBtn:(UIButton *)btn {
    
    self.tempBtn.selected = NO;
    btn.selected = YES;
    self.tempBtn = btn;
    
    CGPoint ofset = self.scrollView.contentOffset;
    ofset.x = btn.tag * self.scrollView.width;
    [self.scrollView setContentOffset:ofset animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.underLineV.centerX = kScreenWidth / 8 + btn.width * btn.tag;
        self.underLineV.width = kScreenWidth / 4;
    }];
    
    self.btn_type = btn.tag;
    
    self.dataSource = [NSMutableArray array];
    
    [self requestDataWithPage:@(self.pageNum).stringValue];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        
        NSInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
        UIButton *btn = self.headView.subviews[index];
        
        
        [self setTableViewFrame];
        
        [self clickTitleBtn:btn];
        
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        [self setTableViewFrame];
    }
}

- (void)setTableViewFrame {
    
    NSInteger index = self.scrollView.contentOffset.x/self.scrollView.width;
    
    [UIView animateWithDuration:0 animations:^{
        self.tableView.frame = CGRectMake(index * kScreenWidth, 0, kScreenWidth, self.scrollView.height);
    }];
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"商品管理";
    /** 右按钮 */
//    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
//    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

}

/** 创建表格 */
- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.scrollView.height)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.scrollView addSubview:self.tableView];
    
    self.tableView.backgroundColor = kColor(234, 234, 236);
    /** 去tableview的线 */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CRGoodsManageCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        
        self.dataSource = [NSMutableArray array];
        
        [self requestDataWithPage:@(self.pageNum).stringValue];
        
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        
        [self requestDataWithPage:@(self.pageNum).stringValue];
        
    }];
    
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRGoodsManageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.row < self.dataSource.count) {
        
        GoodManageModel *model = self.dataSource[indexPath.row];
        
        [cell reloadDataWithModel:model andType:self.btn_type];
    }
    
    cell.clickEditBtnBlock = ^(NSInteger tag, CRGoodsManageCell *goodsCell) {
        
        NSIndexPath *path = [self.tableView indexPathForCell:goodsCell];
        
        GoodManageModel *model1 = self.dataSource[path.row];
        
        if (tag == 1000) {
            
            CRSalePeijianController *salePeiC = [[CRSalePeijianController alloc] init];
            
            /** 编辑 */
            salePeiC.peijianType = 2;
            
            salePeiC.goodid = model1.goodid;
            salePeiC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:salePeiC animated:YES];
            
        } else if (tag == 1001) {
  
            if (self.btn_type == 0 || self.btn_type == 1) {
                
                [self updeteGoodWithID:model1.goodid];
            }

        } else if (tag == 1002) {
            
            ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"是否删除？"];
            [alert addBtnTitle:@"保留" action:^{
                
            }];
            [alert addBtnTitle:@"删除" action:^{
                
                [self deleteGoodWithID:model1.goodid];
   
            }];
            [alert showAlertWithSender:self];
  
        }
        
    };
    
    return cell;
}

- (void)deleteGoodWithID:(NSString *)goodid {
    
    NSString *deleteUrl = [self.baseUrl stringByAppendingString:@"goods/Delete.php"];
    
    [self showHud];
    
    [self.netWork asyncAFNPOST:deleteUrl Param:@[kHDUserId,goodid] Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            [MBProgressHUD alertHUDInView:self.view Text:@"删除成功！" Delegate:self];
 
        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                //跳转登录
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
            } else if (code == 50) {
                
                [MBProgressHUD buildHudWithtitle:@"该商品不存在!" superView:self.view];
                
            } else if (code == 56) {
                
                [MBProgressHUD buildHudWithtitle:@"您没有权限！" superView:self.view];
                
            } else {
                [MBProgressHUD buildHudWithtitle:@"服务器繁忙，请稍后重试!" superView:self.view];
            }
        }
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD buildHudWithtitle:@"无法连接到网络，请稍后再试!" superView:self.view];
    }];
}

- (void)updeteGoodWithID:(NSString *)goodid {
 
    NSString *deleteUrl = [self.baseUrl stringByAppendingString:@"goods/Sj.php"];
    
    [self showHud];
    
    NSArray *array = @[kHDUserId,goodid,@(self.btn_type).stringValue];
    
    [self.netWork asyncAFNPOST:deleteUrl Param:array Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            [MBProgressHUD alertHUDInView:self.view Text:@"修改成功！" Delegate:self];
            
        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                //跳转登录
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
            } else if (code == 50) {
                
                [MBProgressHUD buildHudWithtitle:@"该商品不存在!" superView:self.view];
                
            } else if (code == 56) {
                
                [MBProgressHUD buildHudWithtitle:@"您没有权限！" superView:self.view];
                
            } else {
                [MBProgressHUD buildHudWithtitle:@"服务器繁忙，请稍后重试!" superView:self.view];
            }
        }
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD buildHudWithtitle:@"无法连接到网络，请稍后再试!" superView:self.view];
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    self.pageNum = 1;
    
    self.dataSource = [NSMutableArray array];
    
    [self requestDataWithPage:@(self.pageNum).stringValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    GoodManageModel *model = self.dataSource[indexPath.row];
    
    
    CRProDeatilController *proDetailC = [[CRProDeatilController alloc] init];
    
    proDetailC.hidesBottomBarWhenPushed = YES;
    
    proDetailC.goodid = model.goodid;
    proDetailC.pushType = 1;
    
    [self.navigationController pushViewController:proDetailC animated:YES];
     */
    
}
 
- (void)createBottomView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    btn.titleLabel.font = KFont(16);
    [btn setTitle:@"发布配件" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBottomBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:kImage(@"bgbtnqixiu_quedingkuang") forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)clickBottomBtn {
    
    CRSalePeijianController *submitAccessoriesC = [[CRSalePeijianController alloc] init];
    
    submitAccessoriesC.peijianType = 1;
    [self.navigationController pushViewController:submitAccessoriesC animated:YES];
}



@end
