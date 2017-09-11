//
//  CarModelsViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CarModelsViewController.h"
#import "CarBrandsViewController.h"
#import "CarDepartmentViewController.h"
#import "CarTypeViewController.h"
#import "CRCarDetailModel.h"

#define kHeadWidth kScreenWidth * 0.6 / 3

@interface CarModelsViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *headScrollView;

@property (nonatomic, strong) UIScrollView *bodyScrollView;

@property (nonatomic, strong) UIButton *tempBtn;

@property (nonatomic, strong) UIView *headLineView;

@property (nonatomic, strong) NSMutableArray *carArray;


@end

@implementation CarModelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNav];
    [self buildScrollView];
    [self addchildControll];
    
    NSArray *array = @[@"品牌",@"车系",@"车型"];
    for (int i = 1; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kHeadWidth *(i - 1), 0, kHeadWidth, 50);
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:array[i-1] attributes:@{NSFontAttributeName:KFont(16),NSForegroundColorAttributeName:ColorForRGB(0x828282)}] forState:UIControlStateNormal];
        [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:array[i-1] attributes:@{NSFontAttributeName:KFont(17),NSForegroundColorAttributeName:kColor(37, 37, 37)}] forState:UIControlStateSelected];
        btn.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
        
        [self.headScrollView addSubview:btn];
    }
    
    UIButton *firstBtn = self.headScrollView.subviews.firstObject;
    [self clickBtn:firstBtn];
    [self addchildVC];
    
    UIView *headLineView = [UIView new];
    headLineView.backgroundColor = kColor(37, 37, 37);
    headLineView.height = 1;
    headLineView.y = self.headScrollView.height - headLineView.height;
    [self.headScrollView addSubview:headLineView];
    
    [firstBtn.titleLabel sizeToFit]; // 让label根据文字内容计算尺寸
    
    headLineView.width = firstBtn.titleLabel.width + 5;
    headLineView.centerX = firstBtn.centerX;
    
    self.headLineView = headLineView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:@"CarBrandNoti" object:nil];
}

- (void)receiveNoti:(NSNotification *)noti {

    NSInteger index = [noti.object[@"contentx"] integerValue];
    UIButton *btn = self.headScrollView.subviews[index];
    
    [self clickBtn:btn];
}

- (void)setNav {
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    if (self.subType == 1) {
        /** 右按钮 */
        
        UIBarButtonItem *rightBarButtonItem = [UIBarButtonItem initWithTitle:@"确定" titleColor:[UIColor blackColor] target:self action:@selector(rightBarButtonItemAction)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
    }
}

- (void)addchildVC {
    
    NSInteger index = self.bodyScrollView.contentOffset.x/self.bodyScrollView.width;
    
    UIViewController *viewC = self.childViewControllers[index];
    viewC.view.frame = self.bodyScrollView.bounds;
    [self.bodyScrollView addSubview:viewC.view];
}

- (void)addchildControll {
    
    [self addChildViewController:[[CarBrandsViewController alloc] init] color:[UIColor whiteColor]];
    [self addChildViewController:[[CarDepartmentViewController alloc] init] color:[UIColor whiteColor]];
    CarTypeViewController *carType = [[CarTypeViewController alloc] init];
    carType.subType = self.subType;
    
    carType.returnCarIDBlock = ^(NSMutableArray *array) {
    
        self.carArray = [NSMutableArray array];
        
        self.carArray = array;
    };
    
    carType.singleCellBlock = ^(CRCarDetailModel *model) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if (_singleCellBlock) {
            _singleCellBlock(model);
        }
    };

    
    [self addChildViewController:carType color:[UIColor whiteColor]];
}

- (void)buildScrollView {
    
    UIScrollView *headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.6, 44)];
    self.navigationItem.titleView = headScrollView;
//    headScrollView.contentSize = CGSizeMake(self.view.width, 50);
    headScrollView.showsHorizontalScrollIndicator = NO;
    headScrollView.pagingEnabled = YES;
    self.headScrollView = headScrollView;
    
    UIScrollView *bodyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:bodyScrollView];
    bodyScrollView.contentSize = CGSizeMake(kScreenWidth * 3, 50);
    bodyScrollView.showsHorizontalScrollIndicator = NO;
    bodyScrollView.pagingEnabled = YES;
    bodyScrollView.delegate = self;
    self.bodyScrollView = bodyScrollView;
    
}

- (void)clickBtn:(UIButton *)sender {

    self.tempBtn.selected = NO;
    sender.selected = YES;
    self.tempBtn = sender;

    CGPoint ofset = self.bodyScrollView.contentOffset;
    ofset.x = (sender.tag - 1) * self.bodyScrollView.width;
    [self.bodyScrollView setContentOffset:ofset animated:YES];
    /*
    if (sender.tag == 1) {
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollNoti" object:@{@"scrollType":@(sender.tag - 1).stringValue}];
    }
    */
    [UIView animateWithDuration:0.25 animations:^{
        
        self.headLineView.centerX = sender.centerX;
        self.headLineView.width = sender.titleLabel.width + 5;
        
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bodyScrollView) {
        
        NSInteger index = self.bodyScrollView.contentOffset.x/self.bodyScrollView.width;
        UIButton *btn = self.headScrollView.subviews[index];
        
        [self clickBtn:btn];
       
        [self addchildVC];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (scrollView == self.bodyScrollView) {
        [self addchildVC];
    } else {
        
    }
}

- (void)addChildViewController:(UIViewController *)childController color:(UIColor *)color{
    
    childController.view.backgroundColor = color;
    [self addChildViewController:childController];
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightBarButtonItemAction {
    
    if (_returnCarIDBlock) {
        _returnCarIDBlock(self.carArray);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
