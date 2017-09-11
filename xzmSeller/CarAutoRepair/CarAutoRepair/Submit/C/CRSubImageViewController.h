//
//  CRSubImageViewController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/8.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBaseViewController.h"

typedef void(^returnImageBlock)(NSMutableArray *imageArr,NSMutableArray *imageDataAry,NSMutableArray *deleteAeeay);

@interface CRSubImageViewController : TracyBaseViewController

@property (nonatomic, copy) returnImageBlock returnImageBlock;

@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, strong) NSMutableArray *imageDataAry;

@property (nonatomic, strong) NSMutableArray *editArray;

@property (nonatomic, assign) NSInteger editType;

@end
