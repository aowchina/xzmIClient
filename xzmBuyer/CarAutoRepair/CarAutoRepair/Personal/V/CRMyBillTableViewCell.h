//
//  CRMyBillTableViewCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRBillModel;

@interface CRMyBillTableViewCell : UITableViewCell
/** 方式 */
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 金额 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

/** model */
@property (nonatomic ,strong) CRBillModel *model;

@end
