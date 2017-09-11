//
//  CRAddressViewController.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAddressViewController.h"
#import "CRAddressCell.h"
#import "CRAddressListModel.h"
#import "CRAddAddressViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface CRAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 列表 */
@property (nonatomic ,strong) UITableView *listTableView;
/** 数据 */
@property (nonatomic ,strong) NSMutableArray *dataArr;
/** 添加地址按钮 */
@property (nonatomic ,strong) UIButton *addBtn;

@property (nonatomic,strong) CRAddressListModel *selectModel;

@end

@implementation CRAddressViewController

static NSString *listCell = @"cell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self DataList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 与pan手势冲突
    self.fd_interactivePopDisabled = true;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    [self creatBottomView];
    
    [self creatTableView];
}

- (void)setupNav
{
    self.controllerName = @"收货地址";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - BarButtonItemAction
- (void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatBottomView
{
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setBackgroundImage:kImage(@"address_wdqb_tixiananniu") forState:UIControlStateNormal];
    [_addBtn setTitle:@"添加地址" forState:UIControlStateNormal];
    _addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_addBtn addTarget:self action:@selector(addAddressClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(30);
        make.height.mas_equalTo(42);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
    }];
}

- (void)creatTableView
{
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 90 - IS_HOTSPOT_HEIGHT) style:UITableViewStylePlain];
    
    _listTableView.delegate = self;
    
    _listTableView.dataSource = self;
    
    _listTableView.backgroundColor = [UIColor whiteColor];
    
    _listTableView.tableFooterView = [[UIView alloc] init];
    
    [_listTableView registerClass:[CRAddressCell class] forCellReuseIdentifier:listCell];
    
    [self.view addSubview:_listTableView];
}

- (void)addAddressClick
{
    [self.navigationController pushViewController:[[CRAddAddressViewController alloc] init] animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CRAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
    
    [cell.yesImgBtn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.yesImgBtn.tag = indexPath.row;
    
    if (indexPath.row < self.dataArr.count)
    {
        CRAddressListModel *model =self.dataArr[indexPath.row];
        
        [cell reloadDataWithData:model];
    }
    
    //删除
    [cell deleteBlockWithData:^(CRAddressCell *cell)
     {
         NSIndexPath *indexPath = [tableView indexPathForCell:cell];
         CRAddressListModel *model = self.dataArr[indexPath.row];
         [self DeleteInterfaceWithID:model.ID];
     }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)ClickBtn:(UIButton *)btn
{
    if (self.selectModel) {
        self.selectModel.is_Selected = !self.selectModel.is_Selected;
    }
    CRAddressListModel *model = self.dataArr[btn.tag];
    if (!model.is_Selected) {
        model.is_Selected = !model.is_Selected;
        self.selectModel = model;
    }
    
    //默认收货地址
    [self setDefaultInterfaceWithID:model.ID];
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CRAddressListModel *model = self.dataArr[indexPath.row];
    
    [self setDefaultInterfaceWithID:model.ID];
}

#pragma mark -收货地址列表
-(void)DataList
{
    NSString *AddressList_Url = [self.baseUrl stringByAppendingString:@"user/AddressList.php"];
    
    NSArray *array = @[kHDUserId];
    
    [self showHud];
    [self.netWork asyncAFNPOST:AddressList_Url Param:array Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];

        self.dataArr = [NSMutableArray arrayWithCapacity:1];

        if (!codeErr)
        {
            for (NSDictionary *dic in responseObjc)
            {
                CRAddressListModel *listModel = [CRAddressListModel mj_objectWithKeyValues:dic];
                
                [self.dataArr addObject:listModel];
            }
            
            [self.listTableView reloadData];

        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12)
            {
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

#pragma mark - 删除地址
-(void)DeleteInterfaceWithID:(NSString *)ID
{
    NSString *AddressDelete_Url = [self.baseUrl stringByAppendingString:@"user/AddressDelete.php"];
    
    NSArray *arr = @[kHDUserId,ID];
    
    [self showHud];
    [self.netWork asyncAFNPOST:AddressDelete_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        
        NSInteger code = codeErr.code;
        if (!code)
        {
            [self.dataArr removeAllObjects];
            [self DataList];
            ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"删除成功"];
            [alert addBtnTitle:@"确定" action:^{
                [self.listTableView reloadData];
            }];
            [alert showAlertWithSender:self];
        }
        else if (code == 12 || code == 24)
        {
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else if (code == 39)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"改地址记录不存在或已经删除"];
        }
        else
        {
            //服务器繁忙
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    } Failure:^(NSError *netErr) {
        
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
    
    //刷新控件
    [self.listTableView reloadData];
}


#pragma mark - 默认收货地址
-(void)setDefaultInterfaceWithID:(NSString *)ID
{
    NSString *AddressDefault_Url = [self.baseUrl stringByAppendingString:@"user/AddressDefault.php"];
    NSArray *arr = @[kHDUserId, ID];
    [self showHud];
    [self.netWork asyncAFNPOST:AddressDefault_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        
        NSInteger code = codeErr.code;
        if (!code) {
            
            [self.dataArr removeAllObjects];
            [self DataList];
            
            if (self.makeSureType == 1) {
                
                if (_addressSetSuccess) {
                    _addressSetSuccess();
                }
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"默认收货地址设置成功"];
            [alert addBtnTitle:@"确定" action:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert showAlertWithSender:self];

        }else if (code == 12 || code == 24)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"账号异常，请重新登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else if (code == 39)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"地址记录不存在或已被删除"];
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    } Failure:^(NSError *netErr) {
        
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
    //刷新控件
    [self.listTableView reloadData];
}


@end
