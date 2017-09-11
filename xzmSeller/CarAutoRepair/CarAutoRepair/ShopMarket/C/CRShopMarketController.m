//
//  CRShopMarketController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/18.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRShopMarketController.h"
#import "CRShopMarketCell.h"
#import "DDQLoopView.h"
#import "CRProDeatilController.h"
#import "CRShopMarket.h"

@interface CRShopMarketController () <UITableViewDelegate,UITableViewDataSource,DDQLoopViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic,strong)DDQLoopView *loopScrollView;/** 轮播图 */

@end

@implementation CRShopMarketController

static NSString * const idenyifier = @"shopMarketCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
//    [self buildLoopView];
    [self createTableView];
    [self buildLoopView];
}

- (void)buildLoopView {
    
    self.loopScrollView = [[DDQLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.25)];
    self.loopScrollView.delegate = self;
    
    self.tableView.tableHeaderView = self.loopScrollView;

    self.loopScrollView.source_array = @[@"http://pic17.nipic.com/20111122/6759425_152002413138_2.jpg",@"http://pic.58pic.com/58pic/14/27/45/71r58PICmDM_1024.jpg",@"http://img01.taopic.com/141128/240418-14112P9345826.jpg",@"http://pic.58pic.com/58pic/13/87/72/73t58PICjpT_1024.jpg"];
    
    self.loopScrollView.page_control.numberOfPages = 4;
    
    [self.loopScrollView.loop_collection reloadData];
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"商城";
    
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithTitle:@"筛选" titleColor:ColorForRGB(0x828282) target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    /** 右按钮 */
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_sousuo" target:self action:@selector(rightBarButtonItemAction) width:20 height:20];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

/** 创建表格 */
- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = kColor(234, 234, 236);
    /** 去tableview的线 */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.tableHeaderView = self.loopScrollView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CRShopMarketCell" bundle:nil] forCellReuseIdentifier:idenyifier];
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRShopMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:idenyifier forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenHeight * 0.20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CRProDeatilController *proDetailC = [[CRProDeatilController alloc] init];
    proDetailC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:proDetailC animated:YES];
    
}

#pragma mark - 轮播图点击事件获取

- (void)loopview_selectedMethod:(NSInteger)count {
    
    NSLog(@"%ld",(long)count);
    
}





#pragma mark - BtnAction -
- (void)leftBarButtonItemAction {
    
}

- (void)rightBarButtonItemAction {
    
}


@end
