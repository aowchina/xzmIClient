//
//  CRAccessoriesSubmmitController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

@class CRCarDetailModel;

@interface CRAccessoriesSubmmitController : TracyBaseViewController

@property (nonatomic, assign) NSInteger popType;

@property (nonatomic, strong) CRCarDetailModel *carModel;

@property (nonatomic, strong) NSString *bid;

@end
