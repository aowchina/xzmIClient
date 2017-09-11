//
//  CRProStoreCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/22.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRStoreGoogsModel;

@interface CRProStoreCell : UITableViewCell
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 价钱 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

/** model */
@property (nonatomic ,strong) CRStoreGoogsModel *model;

@end
