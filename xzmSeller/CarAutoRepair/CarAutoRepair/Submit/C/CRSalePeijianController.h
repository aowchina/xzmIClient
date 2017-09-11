//
//  CRSalePeijianController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/27.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

@interface CRSalePeijianController : TracyBaseViewController

@property (nonatomic, assign) NSInteger peijianType;

@property (nonatomic, strong) NSString *goodid;

@property (weak, nonatomic) IBOutlet UITextField *bianmaF;

@property (weak, nonatomic) IBOutlet UITextField *nameF;

@property (nonatomic, strong) NSMutableArray *carArray;

@property (nonatomic, strong) NSString *bianmaStr;
@property (nonatomic, strong) NSString *nameStr;

@end
