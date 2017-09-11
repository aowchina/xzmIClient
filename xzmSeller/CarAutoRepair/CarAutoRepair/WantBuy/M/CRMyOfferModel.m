//
//  CRMyOfferModel.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/14.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRMyOfferModel.h"
#import "CROfferModel.h"

@implementation CRMyOfferModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"iD":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"tpdetail":@"CROfferModel"};
    
}

@end
