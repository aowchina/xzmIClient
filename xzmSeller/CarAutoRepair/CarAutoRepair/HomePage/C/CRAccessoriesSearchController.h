//
//  CRAccessoriesSearchController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

typedef NS_ENUM(NSInteger, PushViewControllerType) {
    
    AccessoriesViewControllerType  = 0,
    OEMViewControllerType
};

@interface CRAccessoriesSearchController : TracyBaseViewController

@property (nonatomic) PushViewControllerType pushType;

@end
