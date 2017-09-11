//
//  CREPCAssDetailViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CREPCAssDetailViewController.h"
#import "CRCarDetailModel.h"
#import "CRSalePeijianController.h"
#import "CRCarDetailModel.h"
#import "CRAccessoriesSubmmitController.h"

@interface CREPCAssDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 名称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** OEM号 */
@property (weak, nonatomic) IBOutlet UILabel *oemLabel;
/** 列表 */
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
/** 列表 */
@property (nonatomic ,strong) UITableView *tableView;
/** model */
@property (nonatomic ,strong) CRCarDetailModel *model;
/** 数据 */
@property (nonatomic ,strong) NSMutableArray *dataArr;
/** 车款总数 */
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

@implementation CREPCAssDetailViewController

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 205, kScreenWidth, kScreenHeight - 205 - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr)
    {
        _dataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    
    [self requestData];
 
    [self.view addSubview:self.tableView];
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"配件详情";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}


- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData
{
    NSString *pjDetail_Url = [self.baseUrl stringByAppendingString:@"cha/pjDetail.php"];
    NSArray *arr = @[kHDUserId,self.epcID,self.ID];
    [self showHud];
    [self.netWork asyncAFNPOST:pjDetail_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSInteger code = codeErr.code;
        
        self.dataArr = [NSMutableArray arrayWithCapacity:1];
        
        NSLog(@"%@",responseObjc);
        
        if (!code)
        {
            NSDictionary *dic = responseObjc[@"object"];
            self.nameLabel.text = [dic objectForKey:@"name"];
            self.oemLabel.text = [NSString stringWithFormat:@"OEM号：%@",[dic objectForKey:@"oem"]];
            self.locationLabel.text = [NSString stringWithFormat:@"位 置：%@",[dic objectForKey:@"position"]];

            for (NSDictionary *dic in responseObjc[@"list"])
            {
                self.model = [CRCarDetailModel mj_objectWithKeyValues:dic];

                [self.dataArr addObject:self.model];
            }
            
            self.totalLabel.text = [NSString stringWithFormat:@"适用%lu款车型",(unsigned long)self.dataArr.count];
            [self.tableView reloadData];
            
        }
        else if (code == 11 || code == 12)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"用户未登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else if (code == 19)
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

#pragma mark - UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarListCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CarListCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.row < self.dataArr.count)
    {
        self.model = self.dataArr[indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.model.bname,self.model.sname,self.model.cname];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 配件出售
- (IBAction)saleBtnClick:(id)sender
{

    CRAccessoriesSubmmitController *accessoriesSubmmitC = [[CRAccessoriesSubmmitController alloc] init];

    self.carDetailModel.popType = @"hand";
    self.carDetailModel.peijianName = self.nameLabel.text;
    accessoriesSubmmitC.carModel = self.carDetailModel;
    
    [self.navigationController pushViewController:accessoriesSubmmitC animated:YES];

    
}



@end
