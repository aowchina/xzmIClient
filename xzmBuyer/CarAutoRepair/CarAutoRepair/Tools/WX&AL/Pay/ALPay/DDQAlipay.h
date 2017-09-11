//
//  DDQAlipay.h
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQAlipay : NSObject

/**
*  唤起支付宝
*
*  @param param_c 支付宝所需参数
*  @param success 支付成功的回调
*  @param failure 支付失败的回调：回调参数为支付宝的错误回调
*/
+ (void)alipay_creatSignWithParam:(NSDictionary *)param_c PaySuccess:(void(^)())success PayFailure:(void(^)(NSDictionary *reslut_dic))failure;

@end

FOUNDATION_EXPORT NSString *const kALOrderId;//支付宝支付时所需的——商户ID
FOUNDATION_EXPORT NSString *const kALGoodsName;//支付宝支付时所需的——商品名称
FOUNDATION_EXPORT NSString *const kALGoodsPrice;//支付宝支付时所需的——商品价格
FOUNDATION_EXPORT NSString *const kAlipayPrivateKey;//支付宝支付时所需的——商品价格

