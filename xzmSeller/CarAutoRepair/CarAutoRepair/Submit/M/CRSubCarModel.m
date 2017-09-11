//
//  CRSubCarModel.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/8.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRSubCarModel.h"
#import "CRSubCarDetailModel.h"

@implementation CRSubCarModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"child":@"CRSubCarDetailModel"};
    
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"typeiD":@"typeid"};
}
@end
