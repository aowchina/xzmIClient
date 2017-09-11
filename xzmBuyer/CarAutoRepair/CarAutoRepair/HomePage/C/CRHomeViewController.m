//
//  CRHomeViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/15.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRHomeViewController.h"
#import "ChatViewController.h"
#import "CRAccessoriesSearchController.h"
#import "CREPCChartViewController.h"
#import "CarModelsViewController.h"
#import "CRChassisNumController.h"
#import "CarModelsViewController.h"
#import "CRCarDetailModel.h"

@interface CRHomeViewController ()

@property (nonatomic, strong) CRCarDetailModel *model;

@end

@implementation CRHomeViewController

#pragma mark - OEM查询
- (IBAction)OEMBtnAction:(UIButton *)sender {
    
    CRAccessoriesSearchController *accessoriesSC = [[CRAccessoriesSearchController alloc] init];
    accessoriesSC.pushType = OEMViewControllerType;
    accessoriesSC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:accessoriesSC animated:YES];
    
}

#pragma mark - 车架号查询
- (IBAction)chejiahaoSearchBtnAction:(UIButton *)sender {

//    CarModelsViewController *carModelsC = [[CarModelsViewController alloc] init];
//    carModelsC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:carModelsC animated:YES];
    
    CRChassisNumController *carModelsC = [[CRChassisNumController alloc] init];
    carModelsC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:carModelsC animated:YES];
    
}

#pragma mark - 配件查询
- (IBAction)peijianSearchBtnAction:(UIButton *)sender {
    
    CRAccessoriesSearchController *accessoriesSC = [[CRAccessoriesSearchController alloc] init];
    accessoriesSC.pushType = AccessoriesViewControllerType;
    accessoriesSC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:accessoriesSC animated:YES];
}

#pragma mark - EPC查询
- (IBAction)EPCAction:(UIButton *)sender {
    
    CREPCChartViewController *EPCChartC = [[CREPCChartViewController alloc] init];
    
    if (self.model) {
        
        EPCChartC.carDetailModel = self.model;
        
        EPCChartC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:EPCChartC animated:YES];
    } else {
        
        [MBProgressHUD alertHUDInView:self.view Text:@"请先选择车型"];
    }
}

#pragma mark - 点头部
- (IBAction)clickHeadBtnAction:(UIButton *)sender {

    CarModelsViewController *carModelsC = [[CarModelsViewController alloc] init];
    
    carModelsC.singleCellBlock = ^(CRCarDetailModel *model) {
        
        self.model = model;
        
        /** 替换图片 */
        UIImageView *imageV = [[UIImageView alloc] init];
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.cimage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [sender setImage:image forState:UIControlStateNormal];
        }];
    };
    
    carModelsC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:carModelsC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.controllerName = @"查看";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];

}

// 统计未读消息数
- (void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
//    if (self) {
//        if (unreadCount > 0) {
//            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            self.tabBarItem.badgeValue = nil;
//        }
//    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

@end
