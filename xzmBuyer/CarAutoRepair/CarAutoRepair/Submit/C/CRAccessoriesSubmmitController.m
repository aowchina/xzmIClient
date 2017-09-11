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

@interface CRAccessoriesSubmmitController () <MBProgressHUDDelegate>

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

@property (nonatomic, strong) CRSubCarDetailModel *model;

//@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, assign) NSInteger bottomHeight;

@end

@implementation CRAccessoriesSubmmitController

static NSString * const identifier = @"chooseImageCell";

static NSString * const identifier_btn = @"chooseBtnCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    self.headViewHeight = 434;
    
    self.oldChang = self.chaiChe = self.brandType = self.otherType = @" ";
    
    [self setHeadView];
    
    if (self.wantID) {
        
        [self requestData];
    } else {
        
        self.bottomHeight = 43;
        
        [self buildBottomView];
    }
    
    

    
    
}

- (void)requestData {
    
    NSString *carSerialUrl = [BaseURL stringByAppendingString:@"goods/BuyDetail.php"];
    
    [self showHud];
    
    [self.netWork asyncAFNPOST:carSerialUrl Param:@[kHDUserId,self.wantID] Success:^(id responseObjc, NSError *codeErr) {
        
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
            
            self.picCollectionView.cantEdit = YES;
            
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
    bottomBtn.frame = CGRectMake(0, kScreenHeight - self.bottomHeight - IS_HOTSPOT_HEIGHT, kScreenWidth, self.bottomHeight);
    [bottomBtn setBackgroundImage:kImage(@"bgbtnqixiu_quedingkuang") forState:UIControlStateNormal];
    [bottomBtn setTitle:@"确定发布" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(clickSubmitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
}

- (void)setHeadView {
    
    self.bottomHeight = self.wantID ? 0 : 43;
    
    self.picCollectionView = [[TracyPicCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.bottomHeight)];
    
    [self.view addSubview:self.picCollectionView];
    
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
    
    if (self.carModel) {
        
        self.headCell.carDetailModel = self.carModel;
        
        self.subView.vinTextF.text = self.carModel.vin;
        
        self.subView.assPeijianTextV.text = self.carModel.peijianName.length > 0 ? self.carModel.peijianName : @"";
        
        if (self.carModel.vin.length > 10) {
            self.subView.vinTextF.userInteractionEnabled = NO;
        } else {
            self.subView.vinTextF.userInteractionEnabled = YES;
        }
    }
    /** 车型选择 */
    headCell.chooseCarBlock = ^() {
        
        CarModelsViewController *carModelsC = [[CarModelsViewController alloc] init];
        
        carModelsC.singleCellBlock = ^(CRCarDetailModel *carModel) {
            
            self.carModel = carModel;
            
            self.carModel.popType = @"hand";
            
            self.headCell.carDetailModel = self.carModel;
            
            self.subView.vinTextF.text = self.carModel.vin;
            
            self.subView.vinTextF.userInteractionEnabled = NO;
            
        };
        
        [self.navigationController pushViewController:carModelsC animated:YES];
    };
    
    subView.changOldBlock = ^(UIButton *btn_sender) {
        
        self.front_btn_type = btn_sender.tag;
        
        self.oldChang = btn_sender.selected == YES ? @"0" : @" ";    };
    
    
    subView.changUIBlock = ^(UIButton *btn_sender) {
        
        self.front_btn_type = btn_sender.tag;
        
        self.chaiChe = btn_sender.selected == YES ? @"1" : @" ";
    };
    
    subView.brand_BtnBlock = ^(UIButton *btn_sender) {
        
        self.brand_btn_type = btn_sender.selected;
        
        self.brandType = btn_sender.selected == YES ? @"2" : @" ";
        
        [self changeSubViewFrame];
        
    };
    
    subView.other_BtnBlock = ^(UIButton *btn_sender) {
        
        self.other_btn_type = btn_sender.selected;
        
        self.otherType = btn_sender.selected == YES ? @"3" : @" ";
        
        [self changeSubViewFrame];
    };
    
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
    self.controllerName = @"配件求购";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSubmitBtnAction {
    
    NSLog(@"%@--%@--%@--%@",self.oldChang,self.chaiChe,self.brandType,self.otherType);
    
    if (!self.carModel) {
        [MBProgressHUD buildHudWithtitle:@"请选择车款！" superView:self.view];
        return;
    }
    
    if ([SuperHelper isEmpty:self.subView.vinTextF.text]) {
        self.subView.vinTextF.text = @" ";
    }
    
    if ([SuperHelper isEmpty:self.subView.assPeijianTextV.text]) {
        [MBProgressHUD buildHudWithtitle:@"请填写配件名称！" superView:self.view];
        return;
    }
    
    NSMutableArray *pinzhiArr = [NSMutableArray array];
    
    [pinzhiArr addObject:self.oldChang];
    [pinzhiArr addObject:self.chaiChe];
    [pinzhiArr addObject:self.brandType];
    [pinzhiArr addObject:self.otherType];
    
    NSLog(@"----%@",pinzhiArr);
    
    [pinzhiArr removeObject:@" "];
    
    NSString *pinzhiStr = [pinzhiArr componentsJoinedByString:@","];
    
    if ([SuperHelper isEmpty:self.subView.limitTextF.text]) {
        self.subView.limitTextF.text = @" ";
    }
    
    if ([SuperHelper isEmpty:self.subView.otherBrandTextF.text]) {
        self.subView.otherBrandTextF.text = @" ";
    }
    
    NSString *brand;
    NSString *chexi;
    NSString *chekuan;
    NSString *carImage;
    
    NSString *chekuanMessage;
    
    if ([self.carModel.popType isEqualToString:@"hand"]) {
        
        brand = self.carModel.bname;
        chexi = self.carModel.bname;
        chekuan = [NSString stringWithFormat:@"车型：%@款 %@",self.carModel.issuedate,self.carModel.bname];
        chekuanMessage = [NSString stringWithFormat:@"%@%@",self.carModel.issuedate,self.carModel.bname];
        carImage = self.carModel.cimage;
    } else {
        
        brand = self.carModel.Brand;
        chexi = self.carModel.Series;
        chekuan = [NSString stringWithFormat:@"车型：%@款 %@",self.carModel.ProducedYear,self.carModel.SalesName];
        chekuanMessage = [NSString stringWithFormat:@"%@%@",self.carModel.issuedate,self.carModel.Brand];
        carImage = self.carModel.cimage;
    }
    
    if ([self.brandType isEqualToString:@" "]) {
        self.subView.limitTextF.text = @" ";
    }
    
    if ([self.otherType isEqualToString:@" "]) {
        self.subView.otherBrandTextF.text = @" ";
    }
    
    if (pinzhiStr.length <= 0) {
        
        [MBProgressHUD buildHudWithtitle:@"请选择品质范围！" superView:self.view];
        return;
    }
    
    NSArray *array = @[kHDUserId,[SuperHelper changeStringUTF:brand],[SuperHelper changeStringUTF:chexi],[SuperHelper changeStringUTF:chekuan],self.subView.vinTextF.text,[SuperHelper changeStringUTF:self.subView.assPeijianTextV.text],pinzhiStr,[SuperHelper changeStringUTF:self.subView.limitTextF.text],[SuperHelper changeStringUTF:self.subView.otherBrandTextF.text],carImage];
    
    NSString *typeUrl = [BaseURL stringByAppendingString:@"goods/WantToBuy.php"];
    
    [self showHud];
    
    [self.netWork asyncPhotoListForPersonWithImageArray:self.picCollectionView.imageArr parameterArray:array url:typeUrl success:^(id responseObjc) {
        
        [self endHud];
        
        NSLog(@"%@",responseObjc);
        
        NSInteger code = [responseObjc[@"errorcode"] integerValue];
        
        if (!code)
        {
            
            [MBProgressHUD alertHUDInView:self.view Text:@"发布成功" Delegate:self];
            
            if (self.popType == 1) {
                
                if (!responseObjc[@"data"][@"id"]) {
                    return;
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendBuyMessage" object:@{@"extType":@"purchaseInfo",@"infoId":responseObjc[@"data"][@"id"],@"name":self.subView.assPeijianTextV.text,@"icon":@"www",@"price":@"",@"carType":chekuanMessage}];
            }
        }
        else if (code == 60)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"vin号不正确"];
        }
        else if (code == 61)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"配件名不合法"];
        }
        else if (code == 63)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"该求购配件已经存在"];
        } else {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    /** 退两级 */
    if (self.popType == 1) {
        
        unsigned long index= [[self.navigationController viewControllers]indexOfObject:self] ;
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2] animated:YES];
        
        
    } else if (self.popType == 2) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"popNoti" object:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

@end
