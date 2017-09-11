//
//  CRAccessoriesListCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/3.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRAccessoriesListCell;

typedef void(^addFriendBlock)(CRAccessoriesListCell *);

@class CRFriendListModel;

@interface CRAccessoriesListCell : UITableViewCell

@property (nonatomic, strong) CRFriendListModel *model;

@property (nonatomic, copy) addFriendBlock addFriendBlock;

@end
