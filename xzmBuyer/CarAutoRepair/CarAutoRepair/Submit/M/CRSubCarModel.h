//
//  CRSubCarModel.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/8.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CRSubCarDetailModel;

@interface CRSubCarModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iD;
@property (nonatomic, strong) NSArray <CRSubCarDetailModel *> *child;

@end
