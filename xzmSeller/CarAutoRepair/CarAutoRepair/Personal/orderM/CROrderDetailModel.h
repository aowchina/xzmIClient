//
//  CROrderDetailModel.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/15.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CROrderDetailModel : NSObject

@property (nonatomic ,strong) NSString *ID;
/** 订单编号 */
@property (nonatomic ,strong) NSString *orderid;

@property (nonatomic ,strong) NSString *goodid;

@property (nonatomic ,strong) NSString *shopid;
/** 商品图片 */
@property (nonatomic ,strong) NSString *img;
/** 商品名字 */
@property (nonatomic ,strong) NSString *name;
/** 商品价钱 */
@property (nonatomic ,strong) NSString *money;
/** 商品数量 */
@property (nonatomic ,strong) NSString *amount;
/** 品牌 */
@property (nonatomic ,strong) NSString *bname;
/** 车系 */
@property (nonatomic ,strong) NSString *sname;
/** 车款 */
@property (nonatomic ,strong) NSString *cname;
/** oem */
@property (nonatomic ,strong) NSString *oem;

@property (nonatomic ,strong) NSString *picture;

@property (nonatomic ,strong) NSString *jname;

@property (nonatomic ,strong) NSString *type;

@property (nonatomic ,strong) NSString *price;

@property (nonatomic ,strong) NSString *total_money;

@property (nonatomic ,assign) NSInteger orderType;

@end
