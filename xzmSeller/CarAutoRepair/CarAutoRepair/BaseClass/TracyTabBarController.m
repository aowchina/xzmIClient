//
//  TracyTabBarController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/15.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyTabBarController.h"
#import "CRHomeViewController.h"
#import "CRPersonalController.h"
//#import "CRShopMarketController.h"
#import "CRWantBuyController.h"
#import "TracyTabBar.h"
#import "CRSubmitView.h"
#import "CRWantAccessoriesController.h"
#import "CRSalePeijianController.h"
#import "CRGoodesManageController.h"
#import "CRChatListViewController.h"
#import "TRPersonalC.h"

@interface TracyTabBarController ()<TracyTabBarDelegate,UITabBarDelegate>

@property (nonatomic, strong) CRSubmitView *submitView;

@end

@implementation TracyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置下tabbar的控制器
    CRHomeViewController *homeVC = [[CRHomeViewController alloc] init];
    [self addChildViewController:homeVC title:@"查看" image:@"qixiu_chacha" selectImage:@"s_qixiu_chacha"];
    
    CRGoodesManageController *goodesManageC = [[CRGoodesManageController alloc] init];
    [self addChildViewController:goodesManageC title:@"商品管理" image:@"qixiu_shangcheng" selectImage:@"s_qixiu_shangcheng"];
    
//    CRChatListViewController *CRChatListVC = [[CRChatListViewController alloc] init];
//    [self addChildViewController:CRChatListVC title:@"消息" image:@"qixiu_xiaoxi" selectImage:@"qixiu_xiaoxixuan"];
    
    CRWantBuyController *wantBuyVC = [[CRWantBuyController alloc] init];
    [self addChildViewController:wantBuyVC title:@"求购" image:@"qixiu_qiugou" selectImage:@"s_qixiu_qiugou"];
    
    CRPersonalController *personalC = [[CRPersonalController alloc] init];
    [self addChildViewController:personalC title:@"我的" image:@"qixiu_wode" selectImage:@"s_qixiu_wode"];
    
//    TRPersonalC *personalC = [[UIStoryboard storyboardWithName:@"TRPersonalC" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSB"];
//    [self addChildViewController:personalC title:@"我的" image:@"qixiu_wode" selectImage:@"s_qixiu_wode"];
    
    //2.更换系统自带的tabbar
    //    self.tabBar = [[TracyTabBar alloc] init];
    TracyTabBar *tabBar = [[TracyTabBar alloc] init];
    tabBar.tabDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWantInfo:) name:@"receiveWantInfo" object:nil];
}

- (void)receiveWantInfo:(NSNotification *)noti {
    
    UITabBarItem *item = [self.tabBar.items objectAtIndex:2];
        // 显示
    NSString *valueStr = noti.object[@"value"];
    
    if ([valueStr integerValue] >= 100) {
        
        valueStr = @"99+";
    }
    
    item.badgeValue = [NSString stringWithFormat:@"%@", valueStr];
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage {
    
    //设置文字样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = ColorForRGB(0x828282);
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = ColorForRGB(0x828282);
    
//    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TabbarIcon"]];
    
    //设置子控制器的文字
    childController.tabBarItem.title = title;
    
    //设置子控制器的图片
    childController.tabBarItem.image = [UIImage imageNamed:image];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置文字样式
    [childController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childController.tabBarItem setTitleTextAttributes:selectTextAttrs  forState:UIControlStateSelected];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}

- (void)tabBarDidClickPlusButton:(TracyTabBar *)tabBar {

    
    [[UIApplication sharedApplication].keyWindow addSubview:self.submitView];
    
    __weak typeof(self) weakSelf = self;
    
    self.submitView.clickPeijianBlock = ^(NSInteger type) {
        
        if (type == 1000) {
            
            CRSalePeijianController *submitAccessoriesC = [[CRSalePeijianController alloc] init];
            [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:submitAccessoriesC] animated:YES completion:nil];
            
        } else {
            
            CRWantAccessoriesController *wantAccessoriesC = [[CRWantAccessoriesController alloc] init];
            [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:wantAccessoriesC] animated:YES completion:nil];
        }
    };
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
/** 移除视图 */
    [self.submitView removeFromSuperview];
    
    if ([tabBar.items objectAtIndex:2]) {
        
        UITabBarItem *item = [self.tabBar.items objectAtIndex:2];
        // 显示
        item.badgeValue = nil;
        
        [kUSER_DEFAULT removeObjectForKey:@"wantBagde"];
    }
    
}

- (CRSubmitView *)submitView
{
    if (!_submitView) {
        _submitView = [CRSubmitView viewFromXib];
        _submitView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 48);
        
    }
    return _submitView;
}



@end
