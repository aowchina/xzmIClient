//
//  CRThirdPartLoginController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/18.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

typedef void(^loginSuccessBlock)();



@interface CRThirdPartLoginController : TracyBaseViewController

@property (nonatomic, copy) loginSuccessBlock loginSuccessBlock;


@end
