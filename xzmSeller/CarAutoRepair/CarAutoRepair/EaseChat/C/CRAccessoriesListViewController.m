//
//  CRAccessoriesListViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/3.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAccessoriesListViewController.h"
#import "CRAccessoriesListCell.h"
#import "TracyCarViewController.h"

@interface CRAccessoriesListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CRAccessoriesListViewController

static NSString * const identifirer = @"accessoriesListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createTableView];
}

- (void)createTableView {
    
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 41) style:UITableViewStylePlain];
    
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tabelView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tabelView];
    
    [tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([CRAccessoriesListCell class]) bundle:nil] forCellReuseIdentifier:identifirer];
    
    self.tableView = tabelView;
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRAccessoriesListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifirer];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}


@end
