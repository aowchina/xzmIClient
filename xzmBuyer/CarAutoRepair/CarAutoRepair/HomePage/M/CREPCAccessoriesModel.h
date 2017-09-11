//
//  CREPCAccessoriesModel.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/9.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CREPCAccessoriesModel : NSObject

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

@end
