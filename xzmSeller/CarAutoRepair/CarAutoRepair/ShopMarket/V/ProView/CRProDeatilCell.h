//
//  CRProDeatilCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRProDetailModel;

@interface CRProDeatilCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidthMargin;

- (void)reloadDataWithModel:(CRProDetailModel *)model andIndex:(NSInteger)index;

@end
