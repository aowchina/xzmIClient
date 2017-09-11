//
//  CRSearchTableViewCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CROEMSearchModel;

@interface CRSearchTableViewCell : UITableViewCell
/** 名称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 品牌名 */
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
/** oem */
@property (weak, nonatomic) IBOutlet UILabel *oemLabel;
/** 价格 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

/** model */
@property (nonatomic ,strong) CROEMSearchModel *model;

@end
