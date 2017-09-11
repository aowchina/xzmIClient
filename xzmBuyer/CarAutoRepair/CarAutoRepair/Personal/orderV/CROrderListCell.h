//
//  CROrderListCell.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/14.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CROrderListModel;

@interface CROrderListCell : UITableViewCell
/** 订单编号 */
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgV;
/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
/** 下单时间 */
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
/** 商品价钱 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
/** 商品数量 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;


- (void)reloadCell:(CROrderListModel *)model Type:(NSInteger )type and:(NSInteger)orderType;


@end
