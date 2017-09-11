//
//  CROEMSearchModel.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/8.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CROEMSearchModel : NSObject

/** 商品名 */
@property (nonatomic ,strong) NSString *name;
/** 品牌 */
@property (nonatomic ,strong) NSString *bname;
/** OEM号 */
@property (nonatomic ,strong) NSString *oem;
/** 价格 */
@property (nonatomic ,strong) NSString *hprice;
/** 图片 */
@property (nonatomic ,strong) NSString *img;
/** 商品ID */
@property (nonatomic ,strong) NSString *goodid;

@property (nonatomic ,strong) NSString *price;

@end
