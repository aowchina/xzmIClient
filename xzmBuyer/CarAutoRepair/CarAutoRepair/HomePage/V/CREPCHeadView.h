//
//  CREPCHeadView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRCarDetailModel;

typedef void(^changeCarBlock)();

@interface CREPCHeadView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (nonatomic, strong) CRCarDetailModel *model;

@property (nonatomic, copy) changeCarBlock changeCarBlock;

@end
