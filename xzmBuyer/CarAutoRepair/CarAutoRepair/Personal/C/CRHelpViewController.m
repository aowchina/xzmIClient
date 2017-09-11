//
//  CRHelpViewController.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRHelpViewController.h"
#import "CRHelpCenterCell.h"
#import "CRHelpModel.h"
#import "CRHelpContentVC.h"

@interface CRHelpViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 列表 */
@property (nonatomic ,strong) UITableView *tableView;
/** 数据 */
@property (nonatomic ,strong) NSMutableArray *listDataArr;

@end

@implementation CRHelpViewController

static NSString * const identifier = @"Cell";

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [[UIView alloc] init];
//        [_tableView registerNib:[UINib nibWithNibName:@"CRHelpCenterCell" bundle:nil] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}

- (NSMutableArray *)listDataArr
{
    if (!_listDataArr)
    {
        _listDataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _listDataArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    
    [self requestData];
    
    [self.view addSubview:self.tableView];
}

- (void)setupNav
{
    self.controllerName = @"帮助中心";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

#pragma mark - BarButtonItemAction
- (void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData
{
    NSString *Help_Url = [self.baseUrl stringByAppendingString:@"user/law.php"];
    NSArray *arr = @[kHDUserId,self.Url_Type];
    [self showHud];
    [self.netWork asyncAFNPOST:Help_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);

        self.listDataArr = [NSMutableArray array];
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            for (NSDictionary *dic in responseObjc)
            {
                CRHelpModel *model = [CRHelpModel mj_objectWithKeyValues:dic];
                
                [self.listDataArr addObject:model];
            }

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
        else if (code == 23)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"帮助中心暂时没有数据"];
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


#pragma mark - UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"helpCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    CRHelpModel *model = self.listDataArr[indexPath.row];

    cell.textLabel.text = model.name;
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CRHelpModel *model = self.listDataArr[indexPath.row];
    
    CRHelpContentVC *helpC = [[CRHelpContentVC alloc] init];
    
    helpC.contentStr = model.url;
    
    helpC.title = model.name;
    
    [self.navigationController pushViewController:helpC animated:YES];
}

@end
