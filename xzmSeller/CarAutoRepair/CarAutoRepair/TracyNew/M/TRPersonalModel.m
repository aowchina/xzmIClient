//
//  TRPersonalModel.m
//  CarAutoRepair
//
//  Created by minfo019 on 2017/8/29.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TRPersonalModel.h"
#import "ItemModel.h"

@implementation TRPersonalModel


+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"item":[ItemModel class]};
}

@end
