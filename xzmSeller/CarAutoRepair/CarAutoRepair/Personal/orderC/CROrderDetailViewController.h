//
//  CROrderDetailViewController.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/5/31.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

@interface CROrderDetailViewController : TracyBaseViewController

/** 订单号 */
@property (nonatomic ,strong) NSString *orderID;
/** 订单类型 */
@property (nonatomic ,assign) NSInteger orderType;

@property (nonatomic, assign) NSInteger qgType;

@end
