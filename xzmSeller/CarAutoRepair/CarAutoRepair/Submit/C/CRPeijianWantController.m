//
//  CRPeijianWantController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/26.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRPeijianWantController.h"
#import "CRCarSearchView.h"
#import "CRAccessoriesWantHeadCell.h"
#import "CRCarDetailModel.h"
#import "CRAccessoriesSubmmitController.h"

@interface CRPeijianWantController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CRCarSearchView *carSearchView;

@property (nonatomic, strong) CRCarDetailModel *vinModel;

@end

@implementation CRPeijianWantController

static NSString * const idenyifier = @"accessoriesWantHeadCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self buildSearchView];
    [self createTableView];
}

#pragma mark - 请求数据
- (void)requestDataWithTextF:(NSString *)textF
{
    
    if ([SuperHelper isEmpty:textF]) {
        [MBProgressHUD buildHudWithtitle:@"请输入17位VIN号" superView:self.view];
        return;
    }
    
    NSString *ChassisNumber_Url = [self.baseUrl stringByAppendingString:@"cha/Vin.php"];
    NSArray *arr = @[kHDUserId,textF];
    [self showHud];
    [self.netWork asyncAFNPOST:ChassisNumber_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSInteger code = codeErr.code;
        
        NSLog(@"%@",responseObjc);
        
        if (!code)
        {
            
            if (responseObjc[@"showapi_res_body"][@"remark"]) {
                [MBProgressHUD buildHudWithtitle:responseObjc[@"showapi_res_body"][@"remark"] superView:self.view];
                self.tableView.hidden = YES;
                return;
            }
            
            self.vinModel = [CRCarDetailModel mj_objectWithKeyValues:responseObjc[@"showapi_res_body"]];
            
            self.vinModel.popType = @"VIN";

            self.tableView.hidden = NO;
            
            [self.tableView reloadData];
            
        }
        else if (code == 12)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"用户未登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else if (code == 13)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请输入车架号"];
        }
        else if (code == 14)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"车架号查询失败"];
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"车架号查询失败!"];
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 50, kScreenWidth, kScreenHeight - 64 - 50) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = kColor(234, 234, 236);
    /** 去tableview的线 */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CRAccessoriesWantHeadCell" bundle:nil] forCellReuseIdentifier:idenyifier];
    
    self.tableView.hidden = YES;
}

- (void)buildSearchView {
    
    CRCarSearchView * carSearchView = [CRCarSearchView viewFromXib];
    
    __weak typeof(self) weakSelf = self;
    
    carSearchView.searchBlock = ^(){
      
        [weakSelf requestDataWithTextF:weakSelf.carSearchView.searchTexfF.text];
    };
    
    carSearchView.frame = CGRectMake(0, 64, kScreenWidth, 50);
    [self.view addSubview:carSearchView];
    
    self.carSearchView = carSearchView;
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"配件求购";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRAccessoriesWantHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:idenyifier forIndexPath:indexPath];
    
    cell.carDetailModel = self.vinModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRAccessoriesSubmmitController *accessoriesSubmmitC = [[CRAccessoriesSubmmitController alloc] init];

    accessoriesSubmmitC.carModel = self.vinModel;
    [self.navigationController pushViewController:accessoriesSubmmitC animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [self createLabelWithFrame:CGRectMake(15, 0, kScreenWidth * 0.5 - 15, 40) andFont:KFont(15) andText:@"查询结果（1个结果）"];
    
    [view addSubview:leftLabel];
    
    UILabel *rightLabel = [self createLabelWithFrame:CGRectMake(kScreenWidth * 0.5, 0, kScreenWidth * 0.5 - 15, 40) andFont:KFont(15) andText:self.vinModel.manufacturer];
    
    rightLabel.textAlignment = NSTextAlignmentRight;
    
    [view addSubview:rightLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    
    lineView.backgroundColor = kColor(229, 229, 231);
    
    [view addSubview:lineView];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [self createLabelWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 40) andFont:KFont(15) andText:[NSString stringWithFormat:@"仅输入VIN号：%@",self.vinModel.vin]];
    
    [view addSubview:leftLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 40;
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)createLabelWithFrame:(CGRect)frame andFont:(UIFont *)font andText:(NSString *)text {
    
    UILabel *label = [UILabel new];
    
    label.font = font;
    
    label.frame = frame;
    
    label.text = text;

    return label;
}

@end
