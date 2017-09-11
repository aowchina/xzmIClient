//
//  CROrderDetailHeaderView.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/5/31.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CROrderDetailHeaderView : UIView
/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 地址 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/** 订单编号 */
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
/** 下单时间 */
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
/** 支付时间 */
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
/** 物流名称 */
@property (weak, nonatomic) IBOutlet UILabel *wuLiuNameLabel;
/** 物流单号 */
@property (weak, nonatomic) IBOutlet UILabel *wuLiuNumberLabel;
/** 发货时间 */
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;
/** 收货时间 */
@property (weak, nonatomic) IBOutlet UILabel *saveTimeLabel;

@end
