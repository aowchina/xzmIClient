//
//  CRSubTypeTableViewCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/8.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRSubCarDetailModel;

@interface CRSubTypeTableViewCell : UITableViewCell

- (void)reloadViewWithModel:(CRSubCarDetailModel *)model;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
