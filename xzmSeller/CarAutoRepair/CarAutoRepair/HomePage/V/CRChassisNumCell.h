//
//  CRChassisNumCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRChassisNumModel;

@interface CRChassisNumCell : UITableViewCell
/** 类型 */
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
/** 值 */
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

/** model */
@property (nonatomic ,strong) CRChassisNumModel *model;

@end
