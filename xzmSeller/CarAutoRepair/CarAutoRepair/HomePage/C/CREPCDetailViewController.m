//
//  CREPCDetailViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CREPCDetailViewController.h"
#import "CREPCDeatilCell.h"
#import "CREPCDetailHeadView.h"
#import "CREPCAssDetailViewController.h"
#import "CREPCDetailModel.h"

@interface CREPCDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CREPCDetailHeadView *epcDetailHeadView;

@property (nonatomic, strong) UITableView *tableView;
/** 数据 */
@property (nonatomic ,strong) NSMutableArray *dataArr;

@end

@implementation CREPCDetailViewController

static NSString * const identifier = @"epcDeatilCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self setNav];
    
    [self requestEpcDeatilData];
    
    [self buildHeadView];
    
    [self createTableView];
}

- (void)buildHeadView {
    
    CREPCDetailHeadView *epcDetailHeadView = [CREPCDetailHeadView viewFromXib];
    epcDetailHeadView.frame = CGRectMake(0, 64, kScreenWidth, 200);
    [self.view addSubview:epcDetailHeadView];
    
    self.epcDetailHeadView = epcDetailHeadView;
    
    [self.epcDetailHeadView.detailImgV sd_setImageWithURL:[NSURL URLWithString:self.headImgV] placeholderImage:kImage(@"CRPlaceholderImage")];
    
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"EPC内部";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - 请求数据
- (void)requestEpcDeatilData
{
    NSString *ChassisNumber_Url = [self.baseUrl stringByAppendingString:@"cha/EpcDetail.php"];
    NSArray *arr = @[kHDUserId,self.epcID];
//    [self showHud];
    [self.netWork asyncAFNPOST:ChassisNumber_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
//        [self endHud];
        NSInteger code = codeErr.code;
        
        self.dataArr = [NSMutableArray arrayWithCapacity:1];
        
        NSLog(@"%@",responseObjc);
        
        if (!code)
        {
            for (NSDictionary *dic in responseObjc)
            {
                CREPCDetailModel *model = [CREPCDetailModel mj_objectWithKeyValues:dic];

                [self.dataArr addObject:model];
            }
            
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 200, kScreenWidth, kScreenHeight - 64 - 200)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    /** 去tableview的线 */
  //  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CREPCDeatilCell" bundle:nil] forCellReuseIdentifier:identifier];
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CREPCDeatilCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.row < self.dataArr.count)
    {
        CREPCDetailModel *model = self.dataArr[indexPath.row];
        
        cell.model = model;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenHeight * 0.10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CREPCDetailModel *model = self.dataArr[indexPath.row];
    CREPCAssDetailViewController *proDetailC = [[CREPCAssDetailViewController alloc] init];
    proDetailC.epcID = self.epcID;
    proDetailC.ID = model.ID;
    [self.navigationController pushViewController:proDetailC animated:YES];

}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
