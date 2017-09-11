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
//    [self createBottomView];
    [self createModaView];
    
    [self requestData];

}

- (void)requestData {
    
    NSString *goodListUrl = [BaseURL stringByAppendingString:@"goods/Detail.php"];
    
    NSArray *arr = @[kHDUserId,self.goodid];
    [self showHud];
    
    [self.netWork asyncAFNPOST:goodListUrl Param:arr Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            NSLog(@"%@",responseObjc);
            
            self.imageArray = responseObjc[@"info"][@"img"];
            
            self.shopID = responseObjc[@"info"][@"shopid"];
            self.price = responseObjc[@"info"][@"price"];
            
            self.model = [CRProDetailModel mj_objectWithKeyValues:responseObjc[@"info"]];
            
            self.model.chooseCount = @(self.model_chooseCount).stringValue;
            
            [self.headView reloadDataWithModel:self.model andImageArr:self.imageArray];
            
            self.footView.model = self.model;
            self.chooseNumView.priceLabel.text = [NSString stringWithFormat:@"¥：%@",self.model.price];
            
            self.tableView.tableHeaderView = self.headView;
            
            [self.tableView reloadData];
            
            
            NSMutableArray *carArr = [NSMutableArray array];
            
            for (NSDictionary * dic in responseObjc[@"info"][@"carList"]) {
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

- (void)changeCollecBtn:(UIButton *)btn
{
    [btn setImage:kImage((i % 2 == 0 ? @"qixiu_hongshoucang" : @"qixiu_shoucangproIcon")) forState:UIControlStateNormal];

    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    k.values = @[@(0.1),@(0.6),@(1.2)];
    
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    
    k.calculationMode = kCAAnimationLinear;
    
    i++;
    
    [btn.layer addAnimation:k forKey:@"SHOW"];
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
        
        [self.navigationController pushViewController:proStoreC animated:YES];
        
    };
    
    if (self.pushType == 1) {
        self.tableView.tableFooterView = footView;
    }

    CRProHeadView *headView = [CRProHeadView viewFromXib];
    
    self.tableView.tableHeaderView = headView;
    
    self.headView = headView;
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    
    if (indexPath.row == 1) {
        
         self.proCarTypeView.hidden = NO;
        
    } 
}



- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
