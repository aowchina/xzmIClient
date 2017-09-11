//
//  CRSendViewController.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"
@class CRWuLiuListModel;
@interface CRSendViewController : TracyBaseViewController

/** 订单编号 */
@property (nonatomic ,strong) NSString *orderID;
/** model */
@property (nonatomic ,strong) CRWuLiuListModel *model;
/** 数据 */
@property (nonatomic ,strong) NSMutableArray *allData;
/** 物流名称数据 */
@property (nonatomic ,strong) NSMutableArray *wuLiuArr;

@property (nonatomic, assign) NSInteger orderType;
@end
