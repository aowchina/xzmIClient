//
//  CROrderListModel.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/15.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CROrderListModel : NSObject

/** 订单编号 */
@property (nonatomic ,strong) NSString *orderid;
/** 商品图片 */
@property (nonatomic ,strong) NSString *img;
/** 商品名字 */
@property (nonatomic ,strong) NSString *name;
/** 下单时间 */
@property (nonatomic ,strong) NSString *addtime;
/** 商品价钱 */
@property (nonatomic ,strong) NSString *money;
/** 商品数量 */
@property (nonatomic ,strong) NSString *amount;



@property (nonatomic ,strong) NSString *qgorderid;

@property (nonatomic ,strong) NSString *picture;

@property (nonatomic ,strong) NSString *jname;

@property (nonatomic ,strong) NSString *type;

@property (nonatomic ,strong) NSString *price;

@property (nonatomic ,strong) NSString *qg_total_money;

@property (nonatomic ,assign) NSInteger orderType;

@end
