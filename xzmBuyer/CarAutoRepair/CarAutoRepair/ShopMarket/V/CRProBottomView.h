//
//  CRProBottomView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickBottomBlock)(NSInteger btn_tag,UIButton *);

@interface CRProBottomView : UIView

/** 收藏按钮 */
@property (weak, nonatomic) IBOutlet UIButton *collecBtn;

@property (nonatomic, copy) clickBottomBlock clickBottomBlock;

@end
