//
//  CRProSecHeaderView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/22.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^leftClick)();
typedef void(^rightClick)();

@interface CRProSecHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *allAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *neAmountLabel;

- (void)setLeftViewColor;

- (void)setRightViewColor;


@property (nonatomic ,strong) leftClick leftBlock;

@property (nonatomic ,strong) rightClick rightBlock;

@end
