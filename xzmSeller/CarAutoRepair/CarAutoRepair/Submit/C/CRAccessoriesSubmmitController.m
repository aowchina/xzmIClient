//
//  CRAccessoriesSubmmitController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAccessoriesSubmmitController.h"
#import "CRAccessoriesSubmitView.h"
#import "CRChooseImageCell.h"
#import "CRChooseBtnCell.h"
#import "CTAssetsPickerController.h"
#import "TracyPicCollectionView.h"
#import "CRAccessoriesWantHeadCell.h"
#import "CarModelsViewController.h"
#import "CRCarDetailModel.h"
#import "CRSubCarDetailModel.h"
#import "CRAccessoriesOfferController.h"

@interface CRAccessoriesSubmmitController ()

@property (nonatomic, strong) CRAccessoriesSubmitView *subView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger front_btn_type;

@property (nonatomic, assign) NSInteger brand_btn_type;

@property (nonatomic, assign) NSInteger other_btn_type;


@property (nonatomic, strong) NSString *oldChang;
@property (nonatomic, strong) NSString *chaiChe;
@property (nonatomic, strong) NSString *brandType;
@property (nonatomic, strong) NSString *otherType;

@property (nonatomic, strong) TracyPicCollectionView *picCollectionView;

@property (nonatomic, strong) CRAccessoriesWantHeadCell *headCell;

@property (nonatomic, assign) NSInteger headViewHeight;/** 头视图高高度 */

//@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) CRSubCarDetailModel *model;

@end

@implementation CRAccessoriesSubmmitController

static NSString * const identifier = @"chooseImageCell";

static NSString * const identifier_btn = @"chooseBtnCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    self.headViewHeight = 434;
    
    self.dataSource = [NSMutableArray array];
    
    [self setHeadView];
    [self buildBottomView];
    
    [self requestData];
}

- (void)requestData {
    
    NSString *carSerialUrl = [BaseURL stringByAppendingString:@"goods/BuyDetail.php"];
    
    [self showHud];
    
    [self.netWork asyncAFNPOST:carSerialUrl Param:@[kHDUserId,self.bid] Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            NSLog(@"%@",responseObjc);
            
            self.model = [CRSubCarDetailModel mj_objectWithKeyValues:responseObjc[@"info"]];
            
            self.model.wantType = @"wantBuy";
            
            self.subView.model = self.model;
            
            self.picCollectionView.imageArr = [NSMutableArray arrayWithArray:responseObjc[@"info"][@"picture"]];
            
            self.headCell.subCarDetailModel = self.model;
            
            NSArray *array = responseObjc[@"info"][@"type"];
            
            for (NSString *str in array) {
                
                if ([str isEqualToString:@"0"]) {
                    
                    self.front_btn_type = 1000;
                    
                } else if ([str isEqualToString:@"1"]) {
                    
                    self.front_btn_type = 1000;
                    
                } else if ([str isEqualToString:@"2"]) {
                    
                    self.brand_btn_type = 1;
                    
                } else if ([str isEqualToString:@"3"]) {
                    
                    self.other_btn_type = 1;
                }
                
            }
            
            [self changeSubViewFrame];

            [self.picCollectionView.collectionView reloadData];
            
        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                /** 跳转登录 */
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

- (void)buildBottomView {
    
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(0, kScreenHeight - 43 - IS_HOTSPOT_HEIGHT, kScreenWidth, 43);
    [bottomBtn setBackgroundImage:kImage(@"bgbtnqixiu_quedingkuang") forState:UIControlStateNormal];
    [bottomBtn setTitle:@"立即报价" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(clickSubmitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
}

- (void)setHeadView {
    
    self.picCollectionView = [[TracyPicCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 43)];
    
    [self.view addSubview:self.picCollectionView];
    
    self.picCollectionView.cantEdit = YES;
    
    self.picCollectionView.headViewHeight = self.headViewHeight;

    CRAccessoriesSubmitView *subView = [CRAccessoriesSubmitView viewFromXib];
    
    subView.frame = CGRectMake(0, 0, kScreenWidth, self.headViewHeight);
    
    [self.picCollectionView.collectionView addSubview:subView];
    
    self.subView = subView;
    
    /** 车型选择视图 */
    CRAccessoriesWantHeadCell *headCell =  [CRAccessoriesWantHeadCell viewFromXib];
    
    headCell.frame = CGRectMake(0, 0, kScreenWidth, 110);
    
    [subView.headView addSubview:headCell];
    
    self.headCell = headCell;
//
//    if (self.carModel) {
//     
//        [self.headCell reloadDataWithCarType:self.carModel];
//        self.subView.vinTextF.text = self.carModel.vin;
//        
//        if (self.carModel.vin.length > 10) {
//            self.subView.vinTextF.userInteractionEnabled = NO;
//        } else {
//            self.subView.vinTextF.userInteractionEnabled = YES;
//        }
//    }
//    /** 车型选择 */
//    headCell.chooseCarBlock = ^() {
//    
//        CarModelsViewController *carModelsC = [[CarModelsViewController alloc] init];
//        
//        carModelsC.singleCellBlock = ^(CRCarDetailModel *carModel) {
//            
//            self.carModel = carModel;
//            
//            self.carModel.popType = @"hand";
//            
//            [self.headCell reloadDataWithCarType:carModel];
//        };
//        
//        [self.navigationController pushViewController:carModelsC animated:YES];
//    };
//    
//    subView.changOldBlock = ^(UIButton *btn_sender) {
//        
//        self.front_btn_type = btn_sender.tag;
//        
//        self.oldChang = btn_sender.selected == YES ? @"0" : @" ";    };
//
//    
//    subView.changUIBlock = ^(UIButton *btn_sender) {
//        
//        self.front_btn_type = btn_sender.tag;
//        
//        self.chaiChe = btn_sender.selected == YES ? @"1" : @" ";
//    };
//    
//    subView.brand_BtnBlock = ^(UIButton *btn_sender) {
//        
//        self.brand_btn_type = btn_sender.selected;
//        
//        self.brandType = btn_sender.selected == YES ? @"2" : @" ";
//
//        [self changeSubViewFrame];
//        
//    };
//    
//    subView.other_BtnBlock = ^(UIButton *btn_sender) {
//        
//        self.other_btn_type = btn_sender.selected;
//        
//        self.otherType = btn_sender.selected == YES ? @"3" : @" ";
//        
//        [self changeSubViewFrame];
//    };

}

/** 改变frame */
- (void)changeSubViewFrame {
    
    if (self.brand_btn_type == 1 && self.other_btn_type == 1) {
        
        self.subView.frame = CGRectMake(0, 0, kScreenWidth, 504);
        
        self.headViewHeight = 504;
        
        self.picCollectionView.headViewHeight = self.headViewHeight;
        
        [self.picCollectionView.collectionView reloadData];
        
    } else if (self.brand_btn_type == 1 || self.other_btn_type == 1) {
        
        self.subView.frame = CGRectMake(0, 0, kScreenWidth, 469);
        
        self.headViewHeight = 469;
        
        self.picCollectionView.headViewHeight = self.headViewHeight;
        
        [self.picCollectionView.collectionView reloadData];
        
    } else {
        
        self.subView.frame = CGRectMake(0, 0, kScreenWidth, 434);
        
        self.headViewHeight = 434;
        
        self.picCollectionView.headViewHeight = self.headViewHeight;
        
        [self.picCollectionView.collectionView reloadData];

    }
    
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"求购详情";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)clickSubmitBtnAction {
    
    
    CRAccessoriesOfferController *offerC = [[CRAccessoriesOfferController alloc] init];
    
    offerC.subCarDetailModel = self.model;
    offerC.offType = 3;
    [self.navigationController pushViewController:offerC animated:YES];
    
//    /** 退两级 */
//    if (self.popType == 1) {
//    
//        unsigned long index= [[self.navigationController viewControllers]indexOfObject:self] ;
//        
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2] animated:YES];
//        
//    
//    } else if (self.popType == 2) {
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    } else {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"popNoti" object:nil];
//        [self.navigationController popViewControllerAnimated:NO];
//    }
}



@end
