//
//  CREPCAssDetailViewController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"
@class CRCarDetailModel;
@interface CREPCAssDetailViewController : TracyBaseViewController
/** oemID */
@property (nonatomic ,strong) NSString *epcID;
/** ID */
@property (nonatomic ,strong) NSString *ID;

@property (nonatomic, strong) CRCarDetailModel *carDetailModel;

@end
