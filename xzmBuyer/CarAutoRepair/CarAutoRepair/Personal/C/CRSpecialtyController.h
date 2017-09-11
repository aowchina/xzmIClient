//
//  CRSpecialtyController.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/8.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

typedef void(^arrBlock)(NSMutableArray *pushArr);
@interface CRSpecialtyController : TracyBaseViewController

/** 传出去的数组 */
@property (nonatomic ,strong) NSMutableArray *pushArr;

@property (nonatomic ,strong) arrBlock arrBlock;

@end
