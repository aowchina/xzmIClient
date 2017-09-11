//
//  CRPersonalController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/15.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRPersonalController.h"
#import "CRPersonalHeaderView.h"
#import "CRMycollectionViewController.h"
#import "CRSettingViewController.h"
#import "CRProStoreViewController.h"
#import "CRWantBuyController.h"

//#import "CRConversationListController.h"
//#import "CROrderListViewController.h"
#import "CRMyBillViewController.h"
//#import "ChatViewController.h"
#import "TracyCarViewController.h"
#import "CRChatListViewController.h"

#import "CRConversationListController.h"
#import "CROrderListVC.h"
#import "CRWalletViewController.h"
#import "CRHelpViewController.h"
#import "CRLawViewController.h"
#import "CRAboutViewController.h"
#import "CRThirdPartShareController.h"
#import "CRGoodesManageController.h"
#import "CROfferBuyViewController.h"
#import "CRKeFuViewController.h"

@interface CRPersonalController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) CRPersonalHeaderView *personHeadView;

@end

@implementation CRPersonalController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self requestData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.array = @[@{@"name":@"我的钱包",@"img":@"qixiu_qianbao"},@{@"name":@"我的消息",@"img":@"qixiu_xiaoxi"},@{@"name":@"我的店铺",@"img":@"qixiu_dianpu"},@{@"name":@"我的报价",@"img":@"qixiu_qiugou"},@{@"name":@"帮助中心",@"img":@"qixiu_bangzhu"},@{@"name":@"法律声明",@"img":@"qixiu_falv"},@{@"name":@"分享",@"img":@"qixiu_fenxiangshare"},@{@"name":@"关于我们",@"img":@"qixiu_guanyu"},@{@"name":@"联系客服",@"img":@"qixiu_kefuaaa"}];
    
    [self createTabelVeiw];
    [self createHeadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshInfo" object:nil];
}

- (void)refreshData {
    
    [self requestData];
}

/** 头视图 */
- (void)createHeadView {
    
    _personHeadView = [CRPersonalHeaderView viewFromXib];
    [self.view addSubview:_personHeadView];
    [_personHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.offset(271);
        make.top.equalTo(self.view.mas_top);
    }];
//    self.tableview.tableHeaderView = personHeadView;
    __weak typeof(self)wself = self;
    _personHeadView.clickSettingBtnBlock = ^(){
      
        CRSettingViewController *settingC = [[CRSettingViewController alloc] init];
        settingC.hidesBottomBarWhenPushed = YES;
        [wself.navigationController pushViewController:settingC animated:YES];
    };
    
    CROrderListVC *orderListVC = [[CROrderListVC alloc] init];
    
    _personHeadView.clickOrderBtnBlock = ^(NSInteger btn_type) {
        
        switch (btn_type) {
            case 0: {   // 待付款
             
                orderListVC.btn_type = btn_type;
                
                orderListVC.hidesBottomBarWhenPushed = YES;
                
                [wself.navigationController pushViewController:orderListVC animated:YES];
            }
                break;
            case 1: {   // 待发货
                
                orderListVC.btn_type = btn_type;
                
                orderListVC.hidesBottomBarWhenPushed = YES;
                
                [wself.navigationController pushViewController:orderListVC animated:YES];
            }
                break;
            case 2: {   // 待收货
                
                orderListVC.btn_type = btn_type;
                
                orderListVC.hidesBottomBarWhenPushed = YES;
                
                [wself.navigationController pushViewController:orderListVC animated:YES];
            }
                break;
            case 3: {   // 待评价
                
                orderListVC.btn_type = btn_type;
                
                orderListVC.hidesBottomBarWhenPushed = YES;
                
                [wself.navigationController pushViewController:orderListVC animated:YES];
            }
                break;
            case 4: {   // 已完成

                orderListVC.btn_type = btn_type;

                orderListVC.hidesBottomBarWhenPushed = YES;
                
                [wself.navigationController pushViewController:orderListVC animated:YES];
            }
                break;
            default:
                break;
        }
        
    };
    
}

#pragma mark - 请求数据
- (void)requestData
{
    NSString *Main_Url = [self.baseUrl stringByAppendingString:@"user/Main.php"];
    NSArray *arr = @[kHDUserId];
    
    MBProgressHUD *hud = [MBProgressHUD instanceHudInView:self.view Text:nil Mode:0 Delegate:nil];
    
    [self.netWork asyncAFNPOST:Main_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [hud hide:YES];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            // 用户姓名
            _personHeadView.nickNameLabel.text = responseObjc[@"name"];
            // 用户头像
            [_personHeadView.headViewImage sd_setImageWithURL:[NSURL URLWithString:responseObjc[@"img"]] placeholderImage:kImage(@"qixiu_touxiang1")];
            [kUSER_DEFAULT setValue:responseObjc[@"img"] forKey:@"userPicture"];
            [kUSER_DEFAULT setValue:responseObjc[@"name"] forKey:@"usernickname"];
        }
        else if (code == 49)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"短信发送失败,请稍后重试"];
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    } Failure:^(NSError *netErr) {
        [hud hide:YES];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}

- (void)createTabelVeiw {
   
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 271, kScreenWidth, kScreenHeight - 271 - 50) style:UITableViewStylePlain];
    
    tabelView.delegate = self;
    tabelView.dataSource = self;
    
    tabelView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tabelView];
    
    self.tableview = tabelView;
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"personalCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.array[indexPath.row][@"img"]]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = kTextFieldColor;
    cell.textLabel.text = self.array[indexPath.row][@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            // 钱包
            CRWalletViewController *walletViewC = [[CRWalletViewController alloc] init];
            walletViewC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:walletViewC animated:YES];
        }
            break;
        case 1: {
            
            
            CRChatListViewController *chatListC = [[CRChatListViewController alloc] init];
            chatListC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatListC animated:YES];

//                EMError *error1 = [[EMClient sharedClient] registerWithUsername:@"138125917161212" password:@"123456"];
//                if (error1==nil) {
//                    NSLog(@"注册成功");
//                }
//                13812591716666
            
            /** 异步 */
            
//             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//               
//                 EMError *error = [[EMClient sharedClient] loginWithUsername:@"20" password:@"13812591716"];
//                 if (!error) {
//                     NSLog(@"登录成功");
//                     
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                         
//                     });
//                     
//                 } else {
//                     NSLog(@"%d",error.code);
//                 }
//            });
            
//            EMError *error = [[EMClient sharedClient] loginWithUsername:@"20" password:@"13812591716"];
//            if (!error) {
//                NSLog(@"登录成功");
//                
//                TracyCarViewController *chatController = [[TracyCarViewController alloc] initWithConversationChatter:@"1371797563566" conversationType:EMConversationTypeChat];
//                
//                chatController.hidesBottomBarWhenPushed = YES;
//
//                [self.navigationController pushViewController:chatController animated:YES];
//                
//                
//            } else {
//                NSLog(@"%d",error.code);
//           }
//
//            
        }
            break;
        case 2: {
            // 我的店铺
            CRProStoreViewController *proStoreViewC = [[CRProStoreViewController alloc] init];
            proStoreViewC.hidesBottomBarWhenPushed = YES;
            proStoreViewC.storeType = 1;
            [self.navigationController pushViewController:proStoreViewC animated:YES];
        }
            break;
        case 3: {
            /** 我的报价 */
            CROfferBuyViewController *offerBuyViewC = [[CROfferBuyViewController alloc] init];
            offerBuyViewC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:offerBuyViewC animated:YES];
        }
            break;
        case 4: {
            // 帮助中心
            CRHelpViewController *helpVC = [[CRHelpViewController alloc] init];
            helpVC.hidesBottomBarWhenPushed = YES;
            helpVC.Url_Type = @"1";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 5: {
            // 法律声明
            CRLawViewController *lawVC = [[CRLawViewController alloc] init];
            lawVC.hidesBottomBarWhenPushed = YES;
            lawVC.Url_Type = @"2";
            [self.navigationController pushViewController:lawVC animated:YES];
        }
            break;
        case 6: {
            // 分享
            CRThirdPartShareController *thirdC = [[CRThirdPartShareController alloc] init];
            thirdC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            thirdC.definesPresentationContext = YES;
            [self presentViewController:thirdC animated:YES completion:nil];
            
        }
            break;
        case 7: {
            // 关于我们
            CRAboutViewController *aboutVC = [[CRAboutViewController alloc] init];
            aboutVC.hidesBottomBarWhenPushed = YES;
            aboutVC.Url_Type = @"3";
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
            case 8: {
                // 联系客服
                CRKeFuViewController *kefuVC = [[CRKeFuViewController alloc] init];
                kefuVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:kefuVC animated:YES];
            }
            break;
        default:
            break;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
@end
