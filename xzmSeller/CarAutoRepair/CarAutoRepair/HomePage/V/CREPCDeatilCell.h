//
//  CREPCDeatilCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CREPCDetailModel;

@interface CREPCDeatilCell : UITableViewCell
/** 位置 */
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
/** 名称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** oem */
@property (weak, nonatomic) IBOutlet UILabel *oemLabel;

/** model */
@property (nonatomic ,strong) CREPCDetailModel *model;

@end
