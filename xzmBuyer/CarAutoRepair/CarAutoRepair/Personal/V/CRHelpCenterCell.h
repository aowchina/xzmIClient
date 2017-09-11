//
//  CRHelpCenterCell.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/12.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRHelpModel;

@interface CRHelpCenterCell : UITableViewCell

/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** model */
@property (nonatomic ,strong) CRHelpModel *model;

@end
