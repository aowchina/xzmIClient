//
//  CRKeFuTableViewCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/7/12.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRkefuModel;

typedef void(^click_btnBlock)(UIButton *);

@interface CRKeFuTableViewCell : UITableViewCell

@property (nonatomic, strong) click_btnBlock click_btnBlock;

@property (nonatomic, strong) CRkefuModel *model;

@end
