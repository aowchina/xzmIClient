//
//  CRSubCarTypeController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/8.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

typedef void(^returnTypeBlock)(NSString *name,NSString *iD);

@interface CRSubCarTypeController : TracyBaseViewController

@property (nonatomic, copy) returnTypeBlock returnTypeBlock;

@end
