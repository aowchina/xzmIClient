//
//  CRSpecialtyController.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/8.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRSpecialtyController.h"

@interface CRSpecialtyController ()<UITableViewDelegate,UITableViewDataSource>
/** 列表 */
@property (nonatomic ,strong) UITableView *tableView;
/** 数据 */
@property (nonatomic ,strong) NSArray *dataArr;
/** 存放选中的数组 */
@property (nonatomic ,strong) NSMutableArray *selectArr;


@end

@implementation CRSpecialtyController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[@"申请服务商",@"申请入驻咨询",@"品牌件",@"原厂件",@"同质件",@"拆车件",@"易损件",@"外观件",@"内饰件",@"钣金件",@"灯具",@"发动机",@"变速箱",@"底盘件",@"电器件",@"油品",@"全车件"];
    
    self.selectArr = [NSMutableArray arrayWithCapacity:1];
    
    [self setNav];
    
    [self creatTableView];
}

- (void)setNav
{
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
- (void)leftBarButtonItemAction {
    
    self.arrBlock(self.selectArr);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建表
- (void)creatTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.editing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;

    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"specialtyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中数据
    [self.selectArr addObject:self.dataArr[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //从选中中取消
    if (self.selectArr.count > 0)
    {
        [self.selectArr removeObject:self.dataArr[indexPath.row]];
    }
    
}

@end
