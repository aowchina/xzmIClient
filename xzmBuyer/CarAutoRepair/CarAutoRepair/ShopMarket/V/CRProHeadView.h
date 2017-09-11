//
//  CRProHeadView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRProDetailModel;

@interface CRProHeadView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proViewWidth;
@property (weak, nonatomic) IBOutlet UIView *scroView;

- (void)reloadDataWithModel:(CRProDetailModel *)model andImageArr:(NSArray *)array;

@end
