//
//  CRMycollectionCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CRMyCollecModel;
typedef void(^cancelBlock)();
@interface CRMycollectionCell : SWTableViewCell
/** 图 */
@property (weak, nonatomic) IBOutlet UIImageView *goodImgView;
/** 商品名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 价钱 */
@property (weak, nonatomic) IBOutlet UILabel *goodPeice;
/** 车款 */
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
/** 车型车系 */
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;


@property (nonatomic ,strong) cancelBlock cancelBlock;

@property (nonatomic ,strong) CRMyCollecModel *model;
@end
