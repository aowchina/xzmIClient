//
//  CRWantBuyModel.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/17.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRWantBuyModel : NSObject

/** 是否是自定义的消息 */
+ (BOOL)iscustomInfo:(NSDictionary *)customDic;

/**
 *  是否是求购信息
 */
+ (BOOL)isBuyInfo:(NSDictionary *)buyDic;


/**
 *  是否是报价信息
 */
+ (BOOL)isOfferInfo:(NSDictionary *)offerDic;


/**
 *  是否是收款信息
 */
+ (BOOL)isCollectionInfo:(NSDictionary *)collectionDic;


/**
 *  是否是商品信息
 */
+ (BOOL)isGoodsInfo:(NSDictionary *)goodsDic;

@end
