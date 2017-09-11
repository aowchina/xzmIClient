//
//  CRProFootView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CRProDetailModel;
typedef void(^clickViewBtnBlock)(NSInteger type);

@interface CRProFootView : UIView


@property (nonatomic, copy) clickViewBtnBlock clickViewBtnBlock;

@property (nonatomic ,strong) CRProDetailModel *model;

@end
