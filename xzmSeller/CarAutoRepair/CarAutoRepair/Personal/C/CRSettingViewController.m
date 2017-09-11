//
//  CRSettingViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/31.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRSettingViewController.h"
#import "CRCertificationController.h"
#import "HDChangePasswordController.h"
#import "CREditInfoViewController.h"
#import "CRAddressViewController.h"

@interface CRSettingViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@end

@implementation CRSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = @[@{@"name":@"修改个人信息",@"img":@"qixiu_sz_xiugainicheng"},@{@"name":@"实名认证",@"img":@"qixiu_sz_shimingrenzheng"},@{@"name":@"修改密码",@"img":@"qixiu_sz_xiugaimima"}];
    
    [self setNav];
    [self createTabelVeiw];
    [self createBottomBtn];
}

- (void)createBottomBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"退出登录" attributes:@{NSFontAttributeName:KFont(16),NSForegroundColorAttributeName:ColorForRGB(0x828282)}] forState:UIControlStateNormal];
    [btn setBackgroundImage:kImage(@"qixiu_sz_tuichuanniu") forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-50);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
}

- (void)clickBtn {
        
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"是否确定退出登录？"];
    [alert addBtnTitle:@"取消" action:^{
 
    }];
    
    [alert addBtnTitle:@"确定" action:^{
        
        [kUSER_DEFAULT removeObjectForKey:@"userId"];
        
        [kUSER_DEFAULT setValue:@"nothirdPart" forKey:@"thirdPart"];
        
        /** 跳转登录 */
        [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CRLoginController alloc] init]];
    }];

    [alert showAlertWithSender:self];
    
}

- (void)createTabelVeiw {
    
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.scrollEnabled = NO;
    
    tabelView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tabelView];
    
    self.tableView = tabelView;
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"设置";
    
    /** 右按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.array[indexPath.row][@"img"]]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = kTextFieldColor;
    cell.textLabel.text = self.array[indexPath.row][@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        
        case 0: {
            // 修改个人信息
            CREditInfoViewController *editInfoViewC = [[CREditInfoViewController alloc] init];
            editInfoViewC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:editInfoViewC animated:YES];
            
        }
            break;
//        case 1: {
//            // 收货地址
//            CRAddressViewController *addressVC = [[CRAddressViewController alloc] init];
//            addressVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:addressVC animated:YES];
//        }
//            break;
        case 1: {
            // 实名认证
            CRCertificationController *certificationC = [[CRCertificationController alloc] init];
            certificationC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:certificationC animated:YES];
        }
            break;
        case 2:{
            // 修改密码
            HDChangePasswordController *changePasswordC = [[HDChangePasswordController alloc] init];
            changePasswordC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:changePasswordC animated:YES];
        }
            break;
            
            
        default:
            break;
    }
    
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
