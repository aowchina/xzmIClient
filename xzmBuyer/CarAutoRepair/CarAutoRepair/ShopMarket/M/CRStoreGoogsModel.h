//
//  CRStoreGoogsModel.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/13.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRStoreGoogsModel : NSObject

/** <#name#> */
@property (nonatomic, strong) NSString *tname;
/** 商品ID */
@property (nonatomic, strong) NSString *goodid;
/** 图片 */
@property (nonatomic, strong) NSString *img;
/** 商品名称 */
@property (nonatomic, strong) NSString *name;
/** 商品价格 */
@property (nonatomic, strong) NSString *price;

@end
