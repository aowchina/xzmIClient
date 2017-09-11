//
//  CRAccessoriesOfferController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/22.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

@class CRSubCarDetailModel;

@class CRShopMarket;
@class CROfferModel;

typedef void(^offerInfoBlock)(NSDictionary *dic);

@interface CRAccessoriesOfferController : TracyBaseViewController

/** 当我的报价进详情显示的状态（1 所有不能点击 3 聊天去报价） */
@property (nonatomic, assign) NSInteger offType;

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, copy) offerInfoBlock offerInfoBlock;

@property (nonatomic, strong) CRShopMarket *shopModel;

@property (nonatomic, strong) CRSubCarDetailModel *subCarDetailModel;

@property (nonatomic, strong) NSArray *offerArr;

@property (nonatomic, strong) NSString *baoId;


@end
