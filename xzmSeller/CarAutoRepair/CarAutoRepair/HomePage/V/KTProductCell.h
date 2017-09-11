//
//  KTProductCell.h
//  KantoCooking
//
//  Created by minfo019 on 17/4/10.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CREPCChartLeftModel;

@interface KTProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;/** 标题 */

/** model */
@property (nonatomic ,strong) CREPCChartLeftModel *model;

@end
