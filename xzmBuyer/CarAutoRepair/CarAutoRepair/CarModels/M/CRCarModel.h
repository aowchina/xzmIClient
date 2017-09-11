//
//  CRCarModel.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/7.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CRCarDetailModel;

@interface CRCarModel : NSObject

@property (nonatomic, strong) NSString *issuedate;
@property (nonatomic, strong) NSArray <CRCarDetailModel *> *info;




@end
