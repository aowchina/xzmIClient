//
//  TRPersonalC.m
//  CarAutoRepair
//
//  Created by minfo019 on 2017/8/29.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TRPersonalC.h"
#import "TRPerCollectionReusableView.h"
#import "TRPerCollectionViewCell.h"
#import "TRPersonalModel.h"
#import "ItemModel.h"

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
#import "CRProStoreViewController.h"
#import "CRMyBillViewController.h"

@interface TRPersonalC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <TRPersonalModel *> *dataSource;

@end

@implementation TRPersonalC

static NSString * const headerIdentifier = @"collectionHeader";

static NSString * const cellIdentifier = @"collectionCell";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];

    [self loadData];
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshInfo" object:nil];
}

- (void)refreshData {
    
    [self requestData];
}

#pragma mark - 请求数据
- (void)requestData
{
    NSString *Main_Url = [self.baseUrl stringByAppendingString:@"user/Main.php"];
    NSArray *arr = @[kHDUserId];
    
    MBProgressHUD *hud = [MBProgressHUD instanceHudInView:self.view Text:nil Mode:0 Delegate:nil];
    
    [self.netWork asyncAFNPOST:Main_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [hud hide:YES];
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            // 用户姓名
            _nickName.text = responseObjc[@"name"];
            // 用户头像
            [_headImage sd_setImageWithURL:[NSURL URLWithString:responseObjc[@"img"]] placeholderImage:kImage(@"qixiu_touxiang1")];
            [kUSER_DEFAULT setValue:responseObjc[@"img"] forKey:@"userPicture"];
            [kUSER_DEFAULT setValue:responseObjc[@"name"] forKey:@"usernickname"];
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

- (void)loadData {
    
    NSArray *array = @[
                       @{@"headname":@"我的询价单",@"item":@[@{@"name":@"待报价(999)",@"image":@"qixiu_daibaojia"},@{@"name":@"已报价",@"image":@"qixiu_yibaojia"},@{@"name":@"已过期",@"image":@"qixiu_yiguoqi"},@{@"name":@"全部",@"image":@"qixiu_quanbu"}]},
                       @{@"headname":@"我的订单",@"item":@[@{@"name":@"待付款",@"image":@"qixiu_daifu"},@{@"name":@"待发货",@"image":@"qixiu_daifa"},@{@"name":@"待收货",@"image":@"qixiu_daishou"},@{@"name":@"待评价",@"image":@"qixiu_daiping"}]},
                       @{@"headname":@"我的钱包",@"item":@[@{@"name":@"账户明细",@"image":@"qixiu_mingxi"},@{@"name":@"货款余额",@"image":@"qixiu_qianbao"}]},
                       @{@"headname":@"我的管理",@"item":@[@{@"name":@"个人信息",@"image":@"qixiu_geenxinxi"},@{@"name":@"店铺信息",@"image":@"qixiu_dianpu"},@{@"name":@"店铺商品",@"image":@"qixiu_qianbao"}]},
                       @{@"headname":@"关于",@"item":@[@{@"name":@"联系客服",@"image":@"qixiu_kefuaaa"},@{@"name":@"帮助中心",@"image":@"qixiu_bangzhu"},@{@"name":@"法律声明",@"image":@"qixiu_falv"},@{@"name":@"关于我们",@"image":@"qixiu_guanyu"},@{@"name":@"分享",@"image":@"qixiu_fenxiangshare"}]}
                       ];
    
    /** 模型处理 */
    self.dataSource = [TRPersonalModel mj_objectArrayWithKeyValuesArray:array];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource[section].item.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TRPerCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    /** 设置字体 */
    item.cellLabel.font = (indexPath.section == 1 || indexPath.section == 0) ? KFont(11) : KFont(12);
    
    ItemModel *model = self.dataSource[indexPath.section].item[indexPath.row];
    
    item.cellImageV.image = [UIImage imageNamed:self.dataSource[indexPath.section].item[indexPath.row].image];
    item.cellLabel.text = model.name;
    
    return item;
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        TRPerCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        
        header.label.text = self.dataSource[indexPath.section].headname;

        return header;
    }
    //如果底部视图
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kScreenWidth - 50) / 4, (kScreenWidth - 50) / 4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 10.0f;
}

/** 点击方法 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {

            case 0: {
                switch (indexPath.row) {
                        case 0: {
                            
                        }
                        break;
                        case 1: {
                            
                        }
                        break;
                        case 2: {
                            
                        }
                        break;
                        case 3: {
                            
                        }
                        break;
                        
                    default:
                        break;
                }
            }
            break;
            case 1: {
                
                CROrderListVC *orderListVC = [[CROrderListVC alloc] init];
                
                orderListVC.btn_type = indexPath.row;
                orderListVC.hidesBottomBarWhenPushed = YES;
        
                [self.navigationController pushViewController:orderListVC animated:YES];
            }
            break;
            case 2: {
                switch (indexPath.row) {
                        case 0: {
                            // 我的账单
                            CRMyBillViewController *myBillC = [[CRMyBillViewController alloc] init];
                            
                            [self.navigationController pushViewController:myBillC animated:YES];
                        }
                        break;
                        case 1: {
                            // 钱包
                            CRWalletViewController *walletViewC = [[CRWalletViewController alloc] init];
                            walletViewC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:walletViewC animated:YES];
                        }
                        break;
                        
                    default:
                        break;
                }
            }
            break;
            case 3: {
                switch (indexPath.row) {
                        case 0: {
                            NSLog(@"个人信息");
                        }
                        break;
                        case 1: {
                            NSLog(@"店铺信息");
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
                        
                    default:
                        break;
                }
            }
            break;
            case 4: {
                switch (indexPath.row) {
                        case 0: {
                            // 联系客服
                            CRKeFuViewController *kefuVC = [[CRKeFuViewController alloc] init];
                            kefuVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:kefuVC animated:YES];
                        }
                        break;
                        case 1: {
                            // 帮助中心
                            CRHelpViewController *helpVC = [[CRHelpViewController alloc] init];
                            helpVC.hidesBottomBarWhenPushed = YES;
                            helpVC.Url_Type = @"1";
                            [self.navigationController pushViewController:helpVC animated:YES];
                        }
                        break;
                        case 2: {
                            // 法律声明
                            CRLawViewController *lawVC = [[CRLawViewController alloc] init];
                            lawVC.hidesBottomBarWhenPushed = YES;
                            lawVC.Url_Type = @"2";
                            [self.navigationController pushViewController:lawVC animated:YES];
                        }
                        break;
                        case 3: {
                            // 关于我们
                            CRAboutViewController *aboutVC = [[CRAboutViewController alloc] init];
                            aboutVC.hidesBottomBarWhenPushed = YES;
                            aboutVC.Url_Type = @"3";
                            [self.navigationController pushViewController:aboutVC animated:YES];
                        }
                        break;
                        case 4: {
                            // 分享
                            CRThirdPartShareController *thirdC = [[CRThirdPartShareController alloc] init];
                            thirdC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                            thirdC.definesPresentationContext = YES;
                            [self presentViewController:thirdC animated:YES completion:nil];
                        }
                        break;
                    default:
                        break;
                }
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
