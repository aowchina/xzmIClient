//
//  CRWantBuyModel.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/17.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRWantBuyModel.h"

@implementation CRWantBuyModel

+ (BOOL)iscustomInfo:(NSDictionary *)customDic {
    
    if ([customDic[@"extType"] isEqualToString:@"priceInfo"] || [customDic[@"extType"] isEqualToString:@"orderInfo"] || [customDic[@"extType"] isEqualToString:@"shopInfo"] || [customDic[@"extType"] isEqualToString:@"purchaseInfo"]) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}


+ (BOOL)isBuyInfo:(NSDictionary *)buyDic {
    
    if ([buyDic[@"extType"] isEqualToString:@"purchaseInfo"]) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}

+ (BOOL)isOfferInfo:(NSDictionary *)offerDic {
    
    if ([offerDic[@"extType"] isEqualToString:@"priceInfo"]) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}

+ (BOOL)isCollectionInfo:(NSDictionary *)collectionDic {
    
    if ([collectionDic[@"extType"] isEqualToString:@"orderInfo"]) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}

+ (BOOL)isGoodsInfo:(NSDictionary *)goodsDic {
    
    if ([goodsDic[@"extType"] isEqualToString:@"shopInfo"]) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}

@end
