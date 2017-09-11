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

typedef void(^offerInfoBlock)(NSDictionary *dic);

@interface CRAccessoriesOfferController : TracyBaseViewController

@property (nonatomic, assign) NSInteger offType;

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, copy) offerInfoBlock offerInfoBlock;

@property (nonatomic, strong) CRShopMarket *shopModel;

@property (nonatomic, strong) CRSubCarDetailModel *subCarDetailModel;

@property (nonatomic, strong) NSString *baoId;

@end
