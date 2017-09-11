//
//  CRShopMarketCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/18.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CRShopMarketCell;

typedef void(^offerBlock)(CRShopMarketCell *);

@class CRShopMarket;

@interface CRShopMarketCell : UITableViewCell

- (void)reloadDataWithModel:(CRShopMarket *)model andTypeStr:(NSString *)typeStr;

@property (nonatomic, copy) offerBlock offerBlock;
@end
