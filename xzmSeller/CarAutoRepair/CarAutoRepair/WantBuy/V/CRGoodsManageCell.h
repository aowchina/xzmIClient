//
//  CRGoodsManageCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/5.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodManageModel;
@class CRGoodsManageCell;

typedef void(^clickEditBtnBlock)(NSInteger,CRGoodsManageCell *);

@interface CRGoodsManageCell : UITableViewCell

- (void)reloadDataWithModel:(GoodManageModel *)model andType:(NSInteger)type;

@property (nonatomic, copy) clickEditBtnBlock clickEditBtnBlock;

@end
