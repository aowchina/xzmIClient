//
//  CREPCChartViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CREPCChartViewController.h"
#import "CREPCHeadView.h"
#import "KTProductCell.h"
#import "CREPCRightCell.h"
#import "CREPCDetailViewController.h"

#import "CREPCChartLeftModel.h"
#import "CREPCChartRightModel.h"
#import "CRCarDetailModel.h"
#import "CarModelsViewController.h"

@interface CREPCChartViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;/** 左边分类 */

@property (nonatomic, strong) UITableView *rightTableView;/** 右边分类 */

@property (nonatomic, strong) CREPCHeadView *epcHeadViwew;  // 头视图

@property (nonatomic, strong) NSString *typeID;/** 类别id */
@property (nonatomic, assign) NSInteger pageNum;/** 页码 */
@property (nonatomic, assign) NSInteger rowNum; /** 第几个 */

@property (nonatomic, strong) NSMutableArray *typeArray;/** 类型 */
@property (nonatomic, strong) NSMutableArray *dataArray;/** 数据源 */
/** 右边头标题 */
@property (nonatomic ,strong) NSMutableArray *headTitleArr;

@end

@implementation CREPCChartViewController

static NSString * const identifier = @"CREPCRightCell";
static NSString * const proIdentifier = @"productCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.typeID = @"1";

    [self setNav];
    [self buildHeadView];
    /** 分类 */
    [self buildTableView];
    
    [self creatRightTableView];
    
    // 左边分类数据
    [self requestLeftDataCarID:self.carDetailModel.carid Row:0];

}

#pragma mark - 请求左边类别数据
- (void)requestLeftDataCarID:(NSString *)carID Row:(NSInteger)row
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    NSString *good_ListUrl = [self.baseUrl stringByAppendingString:@"cha/EpcA.php"];
    
    NSArray *array = @[kHDUserId,carID];
    
    [self showHud];
    
    [self.netWork asyncAFNPOST:good_ListUrl Param:array Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        
        NSLog(@"%@",responseObjc);
        
        self.typeArray = [NSMutableArray array];
        
        if (!codeErr)
        {
             // 产品列表数据源
             for (NSDictionary *dic in responseObjc[@"list"])
             {
                CREPCChartLeftModel *typeModel = [CREPCChartLeftModel mj_objectWithKeyValues:dic];
                 
                 [self.typeArray addObject:typeModel];
             }
            
            self.rightTableView.hidden = NO;
            self.tableView.hidden = NO;
            
            [self.tableView reloadData];

//            if (self.typeID)
//            {
//                [self requestDataWithTypeId:self.typeID];
//            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self.rightTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
        else {
            
            NSInteger code = codeErr.code;
            
            if (code == 12) {
                [MBProgressHUD buildHudWithtitle:@"账号未登录" superView:self.view];
                //未登录
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
            }
            else if (code == 20) {
                
                [MBProgressHUD alertHUDInView:self.view Text:@"暂无发布此EPC结构图"];
                
                self.rightTableView.hidden = YES;
                self.tableView.hidden = YES;
                
            } else {
                //服务器繁忙
                [MBProgressHUD alertHUDInView:self.view Text:kServerError];
                self.rightTableView.hidden = YES;
                self.tableView.hidden = YES;
            }
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];

}

#pragma mark - 请求右边数据
- (void)requestDataWithTypeId:(NSString *)typeId
{
    for (MBProgressHUD *hud in self.view.subviews)
    {
        if ([hud isKindOfClass:[MBProgressHUD class]])
        {
            [hud removeFromSuperview];
        }
    }
    
    NSString *good_ListUrl = [self.baseUrl stringByAppendingString:@"cha/EpcB.php"];
    
    NSArray *array = @[kHDUserId,typeId];
    
    [self showHud];
    
    self.rightTableView.hidden = YES;
    
    [self.netWork asyncAFNPOST:good_ListUrl Param:array Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        
        NSLog(@"%@",responseObjc);
        
        self.dataArray = [NSMutableArray array];
        self.headTitleArr = [NSMutableArray array];
        
        if (!codeErr) {

            for (NSDictionary *dic in responseObjc)
            {
                CREPCChartRightModel *rightModel = [CREPCChartRightModel mj_objectWithKeyValues:dic];
                
                [self.dataArray addObject:rightModel];
            }
            
            self.rightTableView.hidden = NO;
            
            [self.rightTableView reloadData];
        }
        else {
            
            NSInteger code = codeErr.code;
            
            if (code == 12) {
                [MBProgressHUD buildHudWithtitle:@"账号未登录" superView:self.view];
                //未登录
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
            }else if (code == 22) {
                
                [MBProgressHUD alertHUDInView:self.view Text:@"此epc结构图详情暂未发布"];
                
            } else {
                //服务器繁忙
                [MBProgressHUD alertHUDInView:self.view Text:kServerError];
            }
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}


- (void)buildTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 100, 100, kScreenHeight - 64 - 100) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = ColorForRGB(0xf5f5f5);
    
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KTProductCell class]) bundle:nil] forCellReuseIdentifier:proIdentifier];

    self.tableView = tableView;
}

- (void)creatRightTableView
{
    /** 右边的tableview */
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, 64 + 100, kScreenWidth - 100, kScreenHeight - 64 - 100) style:UITableViewStyleGrouped];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rightTableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:rightTableView];
    
    [rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CREPCRightCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    
    self.rightTableView = rightTableView;
}

- (void)buildHeadView {
    
    self.epcHeadViwew = [CREPCHeadView viewFromXib];
    
    self.epcHeadViwew.frame = CGRectMake(0, 64, kScreenWidth, 100);
    
    self.epcHeadViwew.model = self.carDetailModel;
    
    [self.view addSubview:self.epcHeadViwew];
    /** 切换 */
    
    __weak typeof(self) weakSelf = self;
    
    self.epcHeadViwew.changeCarBlock = ^() {
      
        [weakSelf modaCarModelC];
    };
}

- (void)modaCarModelC {
    
    CarModelsViewController *carModelsC = [[CarModelsViewController alloc] init];
    
    carModelsC.singleCellBlock = ^(CRCarDetailModel *model) {
        
        self.carDetailModel = model;
        
        self.epcHeadViwew.model = model;
        
        // 左边分类数据
        [self requestLeftDataCarID:self.carDetailModel.carid Row:0];

    };
    
    carModelsC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:carModelsC animated:YES];
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"EPC结构图";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - tableView -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.tableView) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        return self.typeArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        
        KTProductCell *cell = [tableView dequeueReusableCellWithIdentifier:proIdentifier];
        
        if (indexPath.row < self.typeArray.count)
            {
                CREPCChartLeftModel *typeModel = self.typeArray[indexPath.row];
        
                cell.model = typeModel;
            }

        return cell;
    } else {
        
        CREPCRightCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
            if (indexPath.row < self.dataArray.count) {
        
                CREPCChartRightModel *rightModel = self.dataArray[indexPath.section];
        
                cell.model = rightModel;
            }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return 50;
    } else {
        return 100;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (tableView == self.rightTableView) {
        UILabel *backLabel = [UILabel new];
        
        backLabel.textColor = ColorForRGB(0x828282);
        
        backLabel.font = [UIFont systemFontOfSize:14];
        
        if (section < self.dataArray.count)
        {
            CREPCChartRightModel *rightModel = self.dataArray[section];
            
            backLabel.text = rightModel.epcname;
        }

        return backLabel;
    } else {
        
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.rightTableView) {
        
        return 40;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.typeID = listModel.ID;
//    self.rowNum = indexPath.row;
//    self.pageNum = 1;
//    
//    self.typeArray = [NSMutableArray array];
//    self.dataArray = [NSMutableArray array];
//    
//    [self requestDataWithPage:@(self.pageNum).stringValue andTypeId:listModel.ID andRow:indexPath.row];
    
    if (tableView == self.tableView) {
       CREPCChartLeftModel *listModel = self.typeArray[indexPath.row];
        [self requestDataWithTypeId:listModel.TypeId];
    }
    
    if (tableView == self.rightTableView) {
        
        CREPCDetailViewController *proDetailC = [[CREPCDetailViewController alloc] init];
        CREPCChartRightModel *rightModel = self.dataArray[indexPath.section];
        proDetailC.epcID = rightModel.epcid;
        proDetailC.headImgV = rightModel.epcimg;
        [self.navigationController pushViewController:proDetailC animated:YES];
    }

}


- (void)leftBarButtonItemAction {
 
    [self.navigationController popViewControllerAnimated:YES];
}

@end
