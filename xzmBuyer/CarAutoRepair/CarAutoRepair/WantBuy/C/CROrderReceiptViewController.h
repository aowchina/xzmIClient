//
//  CROrderReceiptViewController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/2.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

typedef void(^makeOfferBlock)(NSDictionary *dic);

@interface CROrderReceiptViewController : TracyBaseViewController

@property (nonatomic, copy) makeOfferBlock makeOfferBlock;
@end
