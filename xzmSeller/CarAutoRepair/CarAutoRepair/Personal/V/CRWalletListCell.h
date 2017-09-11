//
//  CRWalletListCell.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/2.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRTixianModel;

@interface CRWalletListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (nonatomic, strong) CRTixianModel *model;

@end
