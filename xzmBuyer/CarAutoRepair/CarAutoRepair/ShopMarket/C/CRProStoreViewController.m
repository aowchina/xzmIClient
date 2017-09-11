//
//  CRProStoreViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/22.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRProStoreViewController.h"
#import "CRProStoreHeadView.h"
#import "CRProSecHeaderView.h"
#import "CRProStoreCell.h"
#import "CRStoreGoogsModel.h"
#import "CRProDeatilController.h"

@interface CRProStoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) CRProStoreHeadView *headView;
@property (nonatomic ,strong) CRProSecHeaderView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;
/** 页码 */
@property (nonatomic ,assign) NSInteger pageNum;
/** 全部商品数量 */
@property (nonatomic ,assign) NSInteger allGoodsNum;
/** 新品配件数量 */
@property (nonatomic ,assign) NSInteger NewGoodsNum;
/** 左数据 */
@property (nonatomic ,strong) NSMutableArray *leftDataArr;
/** 右数据 */
@property (nonatomic ,strong) NSMutableArray *rightDataArr;


@end

@implementation CRProStoreViewController

static NSString * const idenyifier = @"CRProStoreCell";


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    
    self.leftDataArr = [NSMutableArray arrayWithCapacity:1];
    self.rightDataArr = [NSMutableArray arrayWithCapacity:1];
    
    self.pageNum = 1;
    
    [self requestDataPageNum:@(self.pageNum).stringValue];
    
    [self createTableView];
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"店铺";
    
    /** 右按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

/** 创建表格 */
- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 25) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = kColor(234, 234, 236);
    /** 去tableview的线 */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CRProStoreCell" bundle:nil] forCellReuseIdentifier:idenyifier];
    
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum++;
        
        [self requestDataPageNum:@(self.pageNum).stringValue];
        
        [self.tableView.mj_footer endRefreshing];
    }];
    
    self.headView = [CRProStoreHeadView viewFromXib];
    
    self.tableView.tableHeaderView = self.headView;
}

- (void)requestDataPageNum:(NSString *)pageNum
{
    NSString *Shop_Url = [self.baseUrl stringByAppendingString:@"goods/Shop.php"];
    NSArray *arr = @[kHDUserId,self.shopID,pageNum];
    [self showHud];
    [self.netWork asyncAFNPOST:Shop_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;

        if (!code)
        {
            NSDictionary *infoDic = responseObjc[@"shopInfo"];
            // 店铺名称 手机号隐藏中间四位
            NSString *originTel = [infoDic objectForKey:@"tel"];
            
            NSString *tel;
            if (originTel.length != 0) {
                tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            
            self.headView.nameLabel.text = tel;
            // 店铺销量
            self.headView.amountLabel.text = [NSString stringWithFormat:@"销量\n%@",responseObjc[@"sellCount"]];
            // 全部商品数量
            NSString *str = responseObjc[@"allCount"];
            self.allGoodsNum = [str integerValue];
            // 新品配件数量
            NSString *str1 = responseObjc[@"newCount"];
            self.NewGoodsNum = [str1 integerValue];
            [self.tableView reloadData];
            // 店铺图片
            [self.headView.headImageV sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:@"picture"]] placeholderImage:kImage(@"CRPlaceholderImage")];
            // 店铺好评
            
            if ([[infoDic objectForKey:@"rate"] integerValue] == 0) {
                self.headView.rateLabel.text = @"好评率：100%";
            } else {
                self.headView.rateLabel.text = [NSString stringWithFormat:@"好评率：%@%%",[infoDic objectForKey:@"rate"]];
            }
            if (self.storeType == 1)
            {
                for (NSDictionary *dic in responseObjc[@"allGoods"])
                {
                    CRStoreGoogsModel *allModel = [CRStoreGoogsModel mj_objectWithKeyValues:dic];
                    [self.leftDataArr addObject:allModel];
                }
                [self.tableView reloadData];
            }
            else if (self.storeType == 2)
            {
                for (NSDictionary *dic in responseObjc[@"newGoods"])
                {
                    CRStoreGoogsModel *newModel = [CRStoreGoogsModel mj_objectWithKeyValues:dic];
                    [self.rightDataArr addObject:newModel];
                }
                [self.tableView reloadData];
            }
            else if (code == 10 || code == 11 || code == 28 || code == 32)
            {
                [MBProgressHUD alertHUDInView:self.view Text:@"用户未登录"];
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
            }
            else
            {
                [MBProgressHUD alertHUDInView:self.view Text:kServerError];
            }
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}

#pragma mark - UITableViewDelegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.storeType == 1)
    {
        return self.leftDataArr.count;
    }
    else
    {
        return self.rightDataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRProStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:idenyifier];
    
    if (indexPath.row < self.leftDataArr.count)
    {
        CRStoreGoogsModel *model = self.leftDataArr[indexPath.row];
        
        cell.model = model;
    }
    
    if (indexPath.row < self.rightDataArr.count)
    {
        CRStoreGoogsModel *model = self.rightDataArr[indexPath.row];
        
        cell.model = model;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    self.headerView = [CRProSecHeaderView viewFromXib];
    
    self.headerView.allAmountLabel.text = @(self.allGoodsNum).stringValue;

    self.headerView.neAmountLabel.text = @(self.NewGoodsNum).stringValue;
    
    __weak typeof(self)wself = self;
    self.headerView.leftBlock = ^{
        wself.storeType = 1;
        wself.leftDataArr = [NSMutableArray arrayWithCapacity:1];

        [wself requestDataPageNum:@(wself.pageNum).stringValue];
    };
    
    self.headerView.rightBlock = ^{
        wself.storeType = 2;
        wself.rightDataArr = [NSMutableArray arrayWithCapacity:1];
        [wself requestDataPageNum:@(wself.pageNum).stringValue];
    };
    
    if (self.storeType == 1) {
        
        [self.headerView setLeftViewColor];

    } else {
        
        [self.headerView setRightViewColor];
    }

    

    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRStoreGoogsModel *newModel = nil;
    
    if (self.storeType == 1) {
        
        newModel = self.leftDataArr[indexPath.row];
        
    } else if (self.storeType == 2) {
        
        newModel = self.rightDataArr[indexPath.row];
    }
    
    CRProDeatilController *proDetailC = [[CRProDeatilController alloc] init];
    
    proDetailC.goodid = newModel.goodid;
    
    
    
    [self.navigationController pushViewController:proDetailC animated:YES];
    
}



- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
