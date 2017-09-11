//
//  CRProDeatilController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRProDeatilController.h"
#import "CRProDeatilCell.h"
#import "CRProFootView.h"
#import "CRProHeadView.h"
#import "CRProBottomView.h"
#import "CRProStoreViewController.h"
#import "TracyCarViewController.h"
#import "LLPhotoBrowser.h"
#import "CRProDetailModel.h"
#import "CRMakeSureViewController.h"
#import "CRProChooseNumView.h"
#import "CRProCarTypeView.h"

@interface CRProDeatilController ()<UITableViewDelegate,UITableViewDataSource>
{
    int i;
}

@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) CRProHeadView *headView;
@property (nonatomic, strong) CRProBottomView *bottomView;
@property (nonatomic, strong) CRProFootView *footView;
@property (nonatomic, strong) CRProChooseNumView *chooseNumView;
@property (nonatomic, strong) CRProCarTypeView *proCarTypeView;
@property (nonatomic, strong) NSArray *imageArray;

/**  */
@property (nonatomic ,strong) NSString *shopID;
/** 价格 */
@property (nonatomic ,strong) NSString *price;
/** 数量 */
@property (nonatomic ,strong) NSString *goodNum;

@property (nonatomic ,strong) CRProDetailModel *model;

@property (nonatomic ,assign) NSInteger model_chooseCount;

@end

@implementation CRProDeatilController

static NSString * const idenyifier = @"CRProDeatilCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model_chooseCount = 1;
    
    [self setNav];
    [self createTableView];
    [self createBottomView];
    [self createModaView];
    
    [self requestData];
    
//    // 1 初始化
//    LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc]init];
//    // 2 设置代理
//    photoBrowser.delegate = self;
//    // 3 设置当前图片
//    photoBrowser.currentImageIndex = 0;
//    // 4 设置图片的个数
//    photoBrowser.imageCount = self.imageArray.count;
//    // 5 设置图片的容器
//    photoBrowser.sourceImagesContainerView = self.headView;
//    // 6 展示
//    [photoBrowser show];

}

- (void)requestData {
    
    NSString *goodListUrl = [BaseURL stringByAppendingString:@"goods/Detail.php"];
    
    NSArray *arr = @[kHDUserId,self.goodid];
    [self showHud];
    
    [self.netWork asyncAFNPOST:goodListUrl Param:arr Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            NSLog(@"%@",responseObjc);
            
            self.imageArray = responseObjc[@"img"];
            
            self.shopID = responseObjc[@"shopid"];
            self.price = responseObjc[@"price"];

           self.model = [CRProDetailModel mj_objectWithKeyValues:responseObjc];
            
            self.model.chooseCount = @(self.model_chooseCount).stringValue;

            [self.headView reloadDataWithModel:self.model andImageArr:self.imageArray];
            
            self.footView.model = self.model;
            
            self.bottomView.collecBtn.selected = [self.model.is_collect integerValue];
            
            self.chooseNumView.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.model.price];
            
            self.tableView.tableHeaderView = self.headView;

            [self.tableView reloadData];
            
            
            NSMutableArray *carArr = [NSMutableArray array];
            
            for (NSDictionary * dic in responseObjc[@"carList"]) {
                [carArr addObject:dic[@"cname"]];
            }
            
            self.proCarTypeView.dataArr = carArr;
            
            [self.proCarTypeView.tableView reloadData];
            
        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                //跳转登录
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

- (void)createModaView {
    
    CRProChooseNumView *chooseNumView = [CRProChooseNumView viewFromXib];
    chooseNumView.frame = self.view.bounds;
    
    chooseNumView.hidden = YES;
    
    [self.view addSubview:chooseNumView];
    
    chooseNumView.clickMakeSureBlock = ^(NSString *count) {
      
        self.model.chooseCount = count;
        self.model_chooseCount = [count integerValue];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    };
    self.chooseNumView = chooseNumView;
    
    
    CRProCarTypeView *proCarTypeView = [CRProCarTypeView viewFromXib];
    
    proCarTypeView.frame = self.view.bounds;
    
    proCarTypeView.hidden = YES;
    
    [self.view addSubview:proCarTypeView];
    
    self.proCarTypeView = proCarTypeView;
  
}

// 代理方法 返回图片URL
- (NSURL *)photoBrowser:(LLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{

    NSURL *url = [NSURL URLWithString:self.imageArray[index]];

    return url;
}


- (void)createBottomView {
    
    self.bottomView = [CRProBottomView viewFromXib];
    self.bottomView.frame = CGRectMake(0, kScreenHeight - IS_HOTSPOT_HEIGHT - 50, kScreenWidth, 50);
    [self.view addSubview:self.bottomView];
    
    __weak typeof(self)wself = self;
    self.bottomView.clickBottomBlock = ^(NSInteger btn_tag,UIButton *btn) {
    
        switch (btn_tag) {
            case 1000: {
                
                TracyCarViewController *chatController = [[TracyCarViewController alloc] initWithConversationChatter:[@"sell" stringByAppendingString:wself.model.sellerid] conversationType:EMConversationTypeChat];
                chatController.title = wself.model.sellerName;
                chatController.headUrl = wself.model.blogo;
                
                //chatController.chatType = 1000;
                
//                [chatController sendTextMessage:@"您好，请问这件商品还有吗？"];
                
                [wself.navigationController pushViewController:chatController animated:YES];
                
            }
                break;
            case 1001: {
                // 店铺
                CRProStoreViewController *proStoreC = [[CRProStoreViewController alloc] init];
                proStoreC.storeType = 1;
                proStoreC.shopID = wself.shopID;
                [wself.navigationController pushViewController:proStoreC animated:YES];
     
            }
                break;
            case 1002: {
                
                NSString  *urlStr = [NSString string];
  
                if (btn.selected == YES) {
                    
                    // 取消收藏
                    NSString *DeleteCollectUrl = [BaseURL stringByAppendingString:@"user/DeleteCollect.php"];
                    urlStr = DeleteCollectUrl;
                    
                } else {
                    
                    // 添加收藏
                    NSString *AddCollectUrl = [BaseURL stringByAppendingString:@"user/addCollect.php"];
                    urlStr = AddCollectUrl;
                    
                }
                
                [wself requestCollecBtnClickUrl:urlStr GoodID:wself.goodid andBtn:btn];
                
            }
                break;
            case 1003: {
                // 电话
                
                if (![SuperHelper isMobileNumber:wself.model.sellTel]) {
                    
                    [MBProgressHUD alertHUDInView:wself.view Text:@"商家暂未提供电话号码"];
                    return;
                }
                
                [MBProgressHUD alertHUDInView:wself.view Text:@"请稍等..."];
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",wself.model.sellTel];
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [wself.view addSubview:callWebview];
                
            }
                break;
            case 1004: {
                // 立即购买
                [wself requestToBuyGoodID:wself.goodid ShopID:wself.shopID Price:wself.price GoodNum:wself.model.chooseCount];
            }
                break;
                
            default:
                break;
        }
    };
}

#pragma mark - 收藏点击
- (void)requestCollecBtnClickUrl:(NSString *)url GoodID:(NSString *)goodID andBtn:(UIButton *)btn
{
    NSArray *arr = @[kHDUserId,goodID];
    [self showHud];
    
    [self.netWork asyncAFNPOST:url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            if (btn.selected == YES) {

                [MBProgressHUD alertHUDInView:self.view Text:@"取消收藏"];
                
                self.bottomView.collecBtn.selected = NO;
            }
            else
            {
                [MBProgressHUD alertHUDInView:self.view Text:@"收藏成功"];
                
                self.bottomView.collecBtn.selected = YES;
            }

        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                //跳转登录
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

#pragma mark - 立即购买
- (void)requestToBuyGoodID:(NSString *)goodId ShopID:(NSString *)shopID Price:(NSString *)price GoodNum:(NSString *)goodNum
{
    NSString *ToBuyUrl = [BaseURL stringByAppendingString:@"order/AddToOrder.php"];
    
    NSArray *arr = @[kHDUserId,self.goodid,shopID,price,goodNum];
    [self showHud];
    
    [self.netWork asyncAFNPOST:ToBuyUrl Param:arr Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            NSLog(@"%@",responseObjc);
            
            CRMakeSureViewController *makeSureVC = [[CRMakeSureViewController alloc] init];
            makeSureVC.orderID = responseObjc[@"orderid"];
            makeSureVC.orderType = GoodsOrderType;
            [self.navigationController pushViewController:makeSureVC animated:YES];
            
        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                //跳转登录
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

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"商品详情";

    /** 右按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

/** 创建表格 */
- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 50)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = kColor(234, 234, 236);
    /** 去tableview的线 */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CRProDeatilCell" bundle:nil] forCellReuseIdentifier:idenyifier];
    
    CRProFootView *footView = [CRProFootView viewFromXib];
    
    self.footView = footView;

    footView.clickViewBtnBlock = ^(NSInteger type) {
      
        CRProStoreViewController *proStoreC = [[CRProStoreViewController alloc] init];
        
        if (type == 1000) {

            proStoreC.storeType = 1;
            
        } else {
        
            proStoreC.storeType = 2;
        }
        
        proStoreC.shopID = self.shopID;
        
        [self.navigationController pushViewController:proStoreC animated:YES];
        
    };
    
    self.tableView.tableFooterView = footView;
    
    CRProHeadView *headView = [CRProHeadView viewFromXib];
    
    self.tableView.tableHeaderView = headView;
    
    self.headView = headView;
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRProDeatilCell *cell = [tableView dequeueReusableCellWithIdentifier:idenyifier forIndexPath:indexPath];
    
    [cell reloadDataWithModel:self.model andIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        self.chooseNumView.hidden = NO;
        
    } else if (indexPath.row == 2) {
        
        self.proCarTypeView.hidden = NO;
    }
    
}



- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
