//
//  CREPCDetailViewController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"
@class CRCarDetailModel;
@interface CREPCDetailViewController : TracyBaseViewController

/** EPCid */
@property (nonatomic ,strong) NSString *epcID;
/** 头部图 */
@property (nonatomic ,strong) NSString *headImgV;

@property (nonatomic, strong) CRCarDetailModel *carDetailModel;

@end
