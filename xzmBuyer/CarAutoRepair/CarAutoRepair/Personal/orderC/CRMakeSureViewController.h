//
//  CRMakeSureViewController.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

typedef enum : NSUInteger {
    QGOrderType = 0,
    GoodsOrderType,
} CROrderType;

@interface CRMakeSureViewController : TracyBaseViewController

/** 订单号 */
@property (nonatomic ,strong) NSString *orderID;

/** 求购单还是商品单 */
@property (nonatomic ,assign) CROrderType orderType;


@end
