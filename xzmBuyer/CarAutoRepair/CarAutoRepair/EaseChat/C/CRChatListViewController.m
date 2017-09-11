//
//  CRChatListViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/3.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRChatListViewController.h"
#import "CRConversationListController.h"
#import "CRAccessoriesListViewController.h"
#import "CRFriendsListViewController.h"

#define kHeadWidth kScreenWidth / 3

@interface CRChatListViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIButton *tempBtn;

@property (nonatomic, strong) UIView *headLineView;

@end

@implementation CRChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNav];
    [self buildHeadView];
    [self addchildControll];
    
    NSArray *array = @[@"最近",@"配件商",@"我的好友"];
    for (int i = 1; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kHeadWidth *(i - 1), 0, kHeadWidth, 40);
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:array[i-1] attributes:@{NSFontAttributeName:KFont(16),NSForegroundColorAttributeName:ColorForRGB(0x828282)}] forState:UIControlStateNormal];
        [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:array[i-1] attributes:@{NSFontAttributeName:KFont(17),NSForegroundColorAttributeName:kColor(37, 37, 37)}] forState:UIControlStateSelected];
//        btn.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
        [self.headView addSubview:btn];
    }
    
    UIButton *firstBtn = self.headView.subviews.firstObject;
    [self clickBtn:firstBtn];
    
    UIView *headLineView = [UIView new];
    headLineView.backgroundColor = kColor(37, 37, 37);
    headLineView.height = 1;
    headLineView.y = self.headView.height - headLineView.height;
    [self.headView addSubview:headLineView];
    
    [firstBtn.titleLabel sizeToFit]; // 让label根据文字内容计算尺寸
    
    headLineView.x = firstBtn.x;
    headLineView.width = kHeadWidth;
    
    self.headLineView = headLineView;
}

- (void)setNav {
    
    self.controllerName = @"我的消息";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)addchildControll {
    
    [self addChildViewController:[[CRConversationListController alloc] init] color:[UIColor whiteColor]];
    [self addChildViewController:[[CRAccessoriesListViewController alloc] init] color:[UIColor redColor]];
    [self addChildViewController:[[CRFriendsListViewController alloc] init] color:[UIColor yellowColor]];
}

- (void)buildHeadView {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 + 64, kScreenWidth, 1)];
    lineView.backgroundColor = [kColor(136, 136, 136) colorWithAlphaComponent:0.5];
    [self.view addSubview:lineView];
    
    self.headView = headView;
}

- (void)clickBtn:(UIButton *)sender {
    
    self.tempBtn.selected = NO;
    sender.selected = YES;
    self.tempBtn = sender;
    
//    CGPoint ofset = self.bodyScrollView.contentOffset;
//    ofset.x = (sender.tag - 1) * self.bodyScrollView.width;
//    [self.bodyScrollView setContentOffset:ofset animated:YES];
    
    UIViewController *viewC = self.childViewControllers[sender.tag - 1];
    viewC.view.frame = CGRectMake(0, 64 + 41, kScreenWidth, kScreenHeight - 64 - 41);
    [self.view addSubview:viewC.view];
    [viewC didMoveToParentViewController:self];

    [UIView animateWithDuration:0.25 animations:^{
        
        self.headLineView.centerX = sender.centerX;
        self.headLineView.width = kHeadWidth;
        
    }];
}

- (void)addChildViewController:(UIViewController *)childController color:(UIColor *)color{
    
    childController.view.backgroundColor = color;
    [self addChildViewController:childController];
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
