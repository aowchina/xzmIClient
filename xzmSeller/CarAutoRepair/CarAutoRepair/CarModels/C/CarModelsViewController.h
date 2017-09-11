//
//  CarModelsViewController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

@class CRCarDetailModel;

typedef void(^returnCarIDBlock)(NSMutableArray *);
typedef void(^singleCellBlock)(CRCarDetailModel *);

@interface CarModelsViewController : TracyBaseViewController

@property (nonatomic, assign) NSInteger subType;

@property (nonatomic, copy) returnCarIDBlock returnCarIDBlock;

@property (nonatomic, copy) singleCellBlock singleCellBlock;

@end
