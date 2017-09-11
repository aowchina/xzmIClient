//
//  CRCarBrandModel.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/7.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CRCarInfoModel;

@interface CRCarBrandModel : NSObject

@property (nonatomic, strong) NSString *brandid;
@property (nonatomic, strong) NSString *fname;

@property (nonatomic, strong) NSArray <CRCarInfoModel *>*info;

@end
