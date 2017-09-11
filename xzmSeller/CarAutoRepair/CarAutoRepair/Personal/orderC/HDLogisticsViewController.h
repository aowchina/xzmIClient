//
//  HDLogisticsViewController.h
//  HengDuWS
//
//  Created by minfo019 on 16/7/8.
//  Copyright © 2016年 北京银河盛泰科技有限公司. All rights reserved.
//

#import "TracyBaseViewController.h"

@interface HDLogisticsViewController : TracyBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 确认订单时所需的订单号 */
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *yundanNum;
@property (nonatomic, strong) NSString *wuliuType;

@property (nonatomic, assign) NSInteger orderType;



@end
