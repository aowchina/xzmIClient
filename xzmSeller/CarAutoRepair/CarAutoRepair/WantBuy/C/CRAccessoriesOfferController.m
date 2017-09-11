//
//  CRAccessoriesOfferController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/22.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAccessoriesOfferController.h"
#import "CRAccessoriesWantHeadCell.h"
#import "CROfferTableViewCell.h"
#import "CROfferMoneyHeadView.h"
#import "CRSubCarDetailModel.h"
#import "CRShopMarket.h"
#import "CROfferModel.h"
#import "CRMyOfferModel.h"

@interface CRAccessoriesOfferController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>

@property (nonatomic, strong) CRAccessoriesWantHeadCell *headCell;

@property (weak, nonatomic) IBOutlet UIView *headBackView;/** 头背景图 */
@property (weak, nonatomic) IBOutlet UIView *headView;/** 头cell */
@property (weak, nonatomic) IBOutlet UILabel *vinLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *totalBtn;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *oemLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *buyBottomView;/** 底部付款View */

@property (weak, nonatomic) IBOutlet UIButton *sub_btn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *typeArr;

@property (nonatomic, strong) NSMutableArray *priceArr;

@property (nonatomic, assign) NSInteger count;



@end

@implementation CRAccessoriesOfferController

static NSString * const identifirer = @"offerTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    self.count = 0;
    
    if (self.offType == 1) {
        self.sub_btn.hidden = YES;
        self.buyBottomView.hidden = YES;
    } else {
        self.sub_btn.hidden = NO;
        self.buyBottomView.hidden = YES;
    }
    
    [self setNav];
    [self createTableView];
    
    if (self.baoId) {
        [self requestDataDetail];
    } else {
        [self requestData];
    }
}

- (void)requestDataDetail {
    
    NSArray *array = @[@{@"name":@"原厂",@"price":@"",@"type":@"0"},@{@"name":@"拆车",@"price":@"",@"type":@"1"},@{@"name":@"品牌",@"price":@"",@"type":@"2"},@{@"name":@"其他",@"price":@"",@"type":@"3"}];
    
    for (NSDictionary *dic in array) {
        CROfferModel *model = [CROfferModel mj_objectWithKeyValues:dic];
        
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
    
    NSString *carSerialUrl = [BaseURL stringByAppendingString:@"goods/SetMoneyDetail.php"];
    
    [self showHud];
    
//    if (self.shopModel.iD) {
//        self.baoId = self.shopModel.iD;
//    }
    
    [self.netWork asyncAFNPOST:carSerialUrl Param:@[kHDUserId,self.baoId] Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            NSLog(@"%@",responseObjc);
            
            CRMyOfferModel *model = [CRMyOfferModel mj_objectWithKeyValues:responseObjc[@"info"]];
            
            NSArray *detailArr = model.tpdetail;
            
            if (detailArr.count > 0) {
                
                for (CROfferModel *model in detailArr) {
                    
                    if ([model.type integerValue] == 0) {
                        model.name = @"原厂";
                    } else if ([model.type integerValue] == 1) {
                        model.name = @"拆车";
                    } else if ([model.type integerValue] == 2) {
                        model.name = @"品牌";
                    } else if ([model.type integerValue] == 3) {
                        model.name = @"其他";
                    }
                    
                    if ([model.type integerValue] < 4) {
                        [self.dataSource replaceObjectAtIndex:[model.type integerValue] withObject:model];
                    }
                    
                }
            }
            
            [self.tableView reloadData];
            
            self.subCarDetailModel = [CRSubCarDetailModel mj_objectWithKeyValues:responseObjc[@"info"]];
            self.headCell.subCarDetailModel = self.subCarDetailModel;
            self.vinLabel.text = self.subCarDetailModel.vin;
            self.nameLabel.text = self.subCarDetailModel.jname;
            
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

- (void)requestData {
    
    NSArray *array = @[@{@"name":@"原厂",@"price":@"",@"type":@"0"},@{@"name":@"拆车",@"price":@"",@"type":@"1"},@{@"name":@"品牌",@"price":@"",@"type":@"2"},@{@"name":@"其他",@"price":@"",@"type":@"3"}];
    
    for (NSDictionary *dic in array) {
        
        CROfferModel *model = [CROfferModel mj_objectWithKeyValues:dic];
        
        [self.dataSource addObject:model];
    }
    
    if (self.offerArr.count > 0) {
        
        for (CROfferModel *model in self.offerArr) {
            
            if ([model.type integerValue] == 0) {
                model.name = @"原厂";
            } else if ([model.type integerValue] == 1) {
                model.name = @"拆车";
            } else if ([model.type integerValue] == 2) {
                model.name = @"品牌";
            } else if ([model.type integerValue] == 3) {
                model.name = @"其他";
            }
            
            model.btn_selected = YES;
            
            if ([model.type integerValue] < 4) {
                [self.dataSource replaceObjectAtIndex:[model.type integerValue] withObject:model];
            }
            
        }
        
        self.totalBtn.selected = YES;
        self.amountLabel.text = @(self.offerArr.count).stringValue;
    }

    [self.tableView reloadData];
    
}

- (void)createTableView {
    
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 246 + 64, kScreenWidth, kScreenHeight - 246 - 64 - 48 - IS_HOTSPOT_HEIGHT) style:UITableViewStylePlain];
    
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.scrollEnabled = NO;
    tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tabelView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tabelView];
    
    [tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([CROfferTableViewCell class]) bundle:nil] forCellReuseIdentifier:identifirer];
    
    self.tableView = tabelView;
    
    
    CRAccessoriesWantHeadCell *headCell = [CRAccessoriesWantHeadCell viewFromXib];
    
    headCell.frame = self.headView.bounds;
    
    
    [self.headView addSubview:headCell];
    
    self.headCell = headCell;
    
    if (self.shopModel) {
        self.headCell.shopModel = self.shopModel;
        self.vinLabel.text = self.shopModel.vin;
        self.nameLabel.text = self.shopModel.jname;
    }
    
    if (self.subCarDetailModel) {
        self.headCell.subCarDetailModel = self.subCarDetailModel;
        self.vinLabel.text = self.subCarDetailModel.vin;
        self.nameLabel.text = self.subCarDetailModel.jname;
    }
    
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"配件报价";
    /** 右按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CROfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifirer];
    
    [cell reloadDataWithModel:self.dataSource[indexPath.row] andPushType:self.offType];
    
    cell.textChangeBlock = ^(NSString *text){
        
        /** 赋值模型 */
        CROfferModel *model = self.dataSource[indexPath.row];
        model.price = [NSString stringWithFormat:@"%.2f",[text floatValue]];
    };
    
    cell.priceBlock = ^(UIButton *btn, CROfferTableViewCell *cell) {
        NSIndexPath *index = [self.tableView indexPathForCell:cell];
        
        /** 赋值模型 */
        CROfferModel *model = self.dataSource[index.row];
        
        btn.selected = !btn.selected;
        
        model.btn_selected = btn.selected;
        
        model.price = [NSString stringWithFormat:@"%.2f",[cell.midTextF.text floatValue]];
        
        if (btn.selected == YES) {
            self.count ++;
        } else {
            self.count --;
        }
        
        self.amountLabel.text = @(self.count).stringValue;
        
        self.totalBtn.selected = self.count > 0 ? YES : NO;
        
        [self.tableView reloadData];
        
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CROfferMoneyHeadView *moneyHeadView = [CROfferMoneyHeadView viewFromXib];
    
    return moneyHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (IBAction)baojiaBtn:(UIButton *)sender {
    
    //    [self.navigationController popViewControllerAnimated:YES];
    //
    //    if (_offerInfoBlock) {
    //
    //        _offerInfoBlock(@{@"offerInfo":self.numTextF.text,@"moneyInfo":self.moneyTextF.text});
    //    }
}

- (IBAction)buyBtnAction:(UIButton *)sender {
    
    
}

- (IBAction)subBtnAction:(UIButton *)sender {
    
    self.typeArr = [NSMutableArray array];
    self.priceArr = [NSMutableArray array];
    
    NSString *carSerialUrl = [BaseURL stringByAppendingString:@"goods/SetMoney.php"];
    
    for (CROfferModel *model in self.dataSource) {
        
        if (model.btn_selected == YES) {
            
            [self.typeArr addObject:model.type];
            [self.priceArr addObject:model.price];
        }
    }
    
    if (self.typeArr.count <= 0) {
        [MBProgressHUD alertHUDInView:self.view Text:@"请填写需要的价格"];
   
        return;
    }
    
    NSString *typeStr = [self.typeArr componentsJoinedByString:@","];
    NSString *priceStr = [self.priceArr componentsJoinedByString:@","];
    
    NSString *bStr;
    NSString *pStr;
    
    if (self.shopModel) {
        
        bStr = self.shopModel.bid;
        pStr = self.shopModel.appuid;
    }
    
    if (self.subCarDetailModel) {
        bStr = self.subCarDetailModel.bid;
        pStr = self.subCarDetailModel.appuid;
    }
    
    NSArray *array = @[kHDUserId,bStr,pStr,typeStr,priceStr];
    
    NSLog(@"%@",array);
    
    [self showHud];
    
    [self.netWork asyncAFNPOST:carSerialUrl Param:array Success:^(id responseObjc, NSError *codeErr) {
        
        [self endHud];
        
        if (!codeErr) {
            
            [MBProgressHUD alertHUDInView:self.view Text:@"报价成功" Delegate:self];
            
            if (self.offType == 3) {
                
                if (!responseObjc[@"setMoneyId"]) {
                    
                    return;
                }
                
                NSString *typeStr = self.headCell.chexingLabel.text;
                if (typeStr.length > 4) {
                    typeStr = [typeStr stringByReplacingOccurrencesOfString:@"车型：" withString:@""];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendOfferMessage" object:@{@"extType":@"priceInfo",@"infoId":responseObjc[@"setMoneyId"],@"name":self.nameLabel.text,@"icon":@"www",@"price":self.priceArr.firstObject,@"carType":typeStr}];
                
            }

        } else {
            NSInteger code = codeErr.code;
            if (code == 10 || code == 11 || code == 12) {
                /** 跳转登录 */
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
                
            } else if (code == 32) {
              
                [MBProgressHUD alertHUDInView:self.view Text:@"请不要重复报价"];
                
            } else {
                [MBProgressHUD buildHudWithtitle:@"服务器繁忙，请稍后重试!" superView:self.view];
            }
        }
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD buildHudWithtitle:@"无法连接到网络，请稍后再试!" superView:self.view];
    }];
    
    //    if (_offerInfoBlock) {
    //        _offerInfoBlock(@{@"extType":@"priceInfo",@"infoId":@"10086",@"name":@"奔驰",@"icon":@"www",@"price":@"100",@"carType":@"奔驰A"});
    //    }
    //    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    /** 退两级 */
    if (self.offType == 3) {
        
        unsigned long index= [[self.navigationController viewControllers]indexOfObject:self] ;
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2] animated:YES];
        
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
