//
//  CROrderListHeaderView.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/5/31.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CROrderListHeaderView : UIView
/** 订单编号 */
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
/** 订单状态 */
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

- (void)reloadCellType:(NSInteger)type;

@end
