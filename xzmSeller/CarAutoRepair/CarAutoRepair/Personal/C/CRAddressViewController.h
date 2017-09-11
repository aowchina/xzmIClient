//
//  CRAddressViewController.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

typedef void(^addressSetSuccess)();

typedef void(^SelectedAddress)();

@interface CRAddressViewController : TracyBaseViewController

@property (nonatomic, assign) NSInteger makeSureType;

@property (nonatomic, strong) addressSetSuccess addressSetSuccess;

@end
