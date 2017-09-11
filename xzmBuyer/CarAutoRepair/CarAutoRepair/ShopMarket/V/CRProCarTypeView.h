//
//  CRProCarTypeView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/20.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRProCarTypeView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end
