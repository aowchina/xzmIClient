//
//  CRShopMarketCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/18.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRShopMarketCell;
@class CRMyOfferModel;

typedef void(^offerBlock)(CRShopMarketCell *);

@class CRShopMarket;

@interface CRShopMarketCell : UITableViewCell

- (void)reloadDataWithModel:(CRShopMarket *)model andTypeStr:(NSString *)typeStr;

@property (nonatomic, strong) CRMyOfferModel *model;

@property (nonatomic, copy) offerBlock offerBlock;
@end
