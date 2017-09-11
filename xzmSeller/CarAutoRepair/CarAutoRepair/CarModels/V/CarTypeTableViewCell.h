//
//  CarTypeTableViewCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRCarDetailModel;

@interface CarTypeTableViewCell : UITableViewCell

- (void)reloadViewWithModel:(CRCarDetailModel *)model andType:(NSInteger)type;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
