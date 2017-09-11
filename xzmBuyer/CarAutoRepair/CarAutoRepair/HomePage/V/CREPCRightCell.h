//
//  CREPCRightCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CREPCChartRightModel;

@interface CREPCRightCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;


/** model */
@property (nonatomic ,strong) CREPCChartRightModel *model;

@end
