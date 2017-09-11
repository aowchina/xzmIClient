//
//  CRAccessoriesWantHeadCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRCarDetailModel;
@class CRSubCarDetailModel;
@class CRShopMarket;

typedef void(^chooseCarBlock)();

@interface CRAccessoriesWantHeadCell : UITableViewCell

@property (nonatomic, strong) chooseCarBlock chooseCarBlock;

//- (void)reloadDataWithCarType:(CRCarDetailModel *)model andModel:(CRSubCarDetailModel *)subModel;

@property (nonatomic, strong) CRCarDetailModel *carDetailModel;

@property (nonatomic, strong) CRSubCarDetailModel *subCarDetailModel;

@property (nonatomic, strong) CRShopMarket *shopModel;

@property (weak, nonatomic) IBOutlet UILabel *chexingLabel;

@end
