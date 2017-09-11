//
//  CRMyCollecModel.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRMyCollecModel : NSObject

@property (nonatomic ,strong) NSString *goodid;

@property (nonatomic ,strong) NSString *hprice;
/** 品牌名称 */
@property (nonatomic ,strong) NSString *bname;
/** 商品图片 */
@property (nonatomic ,strong) NSString *img;
/** 系统名称 */
@property (nonatomic ,strong) NSString *sname;
/** 车款名称 */
@property (nonatomic ,strong) NSString *cname;
/** 商品名称 */
@property (nonatomic ,strong) NSString *name;

@property (nonatomic ,strong) NSString *price;

@end
