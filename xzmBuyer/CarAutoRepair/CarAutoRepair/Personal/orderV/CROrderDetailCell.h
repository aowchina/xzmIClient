//
//  CROrderDetailCell.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/5/31.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CROrderDetailModel;

@interface CROrderDetailCell : UITableViewCell
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *smallImgView;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 价钱 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/** 数量 */
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
/** 车型 */
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
/** 型号 */
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
/** model */
@property (nonatomic ,strong) CROrderDetailModel *model;

@end
