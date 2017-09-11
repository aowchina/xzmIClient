//
//  CarTypeViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CarTypeViewController.h"
#import "KTProductCell.h"
#import "CarTypeTableViewCell.h"
#import "CarTypeHeadView.h"
#import "CRCarModel.h"
#import "CRCarDetailModel.h"

@interface CarTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;/** 分类 */
@property (nonatomic, strong) UITableView *rightTableView;/** 分类 */

@property (nonatomic, strong) NSMutableArray <CRCarModel *>*dataSource;/** 数据源 */

@property (nonatomic, strong) CarTypeHeadView *carTypeHeadView;

@property (nonatomic, assign) NSInteger selectRow;

@property (nonatomic, assign) NSInteger requType;

@property (nonatomic, strong) NSMutableArray *carArray;

@end

@implementation CarTypeViewController

static NSString * const proIdentifier = @"productCell";

static NSString * const identifier = @"carTypeTableViewCell";

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.requType != 1) {
        [MBProgressHUD buildHudWithtitle:@"请先选择车系" superView:self.view];
        
        self.rightTableView.tableHeaderView = [[UIView alloc] init];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.carArray = [NSMutableArray array];
    
    /** 分类 */
    [self buildTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:@"CarBrandNoti" object:nil];
    
    NSLog(@"%d",self.subType);
    
}

- (void)receiveNoti:(NSNotification *)noti {
    
    if ([noti.object[@"contentx"] integerValue] != 2) {
        return;
    }
    
    self.carArray = [NSMutableArray array];
    
    self.requType = 1;
    
    self.dataSource = [NSMutableArray array];
    
    self.selectRow = 0;
    
    NSLog(@"%@",noti.object[@"serialid"]);
    
    self.carTypeHeadView.headLabel.text = noti.object[@"sname"];
    
    [self requestDataWithTypeId:noti.object[@"serialid"]];
}


- (void)requestDataWithTypeId:(NSString *)typeId {
    
    
    NSString *carUrl = [BaseURL stringByAppendingString:@"car/Car.php"];
    
    NSArray *array = @[kHDUserId,typeId];
    
    [self showHud];
    
    self.rightTableView.hidden = YES;
    
    [self.netWork asyncAFNPOST:carUrl Param:array Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        
        if (!codeErr) {
            
            NSLog(@"bbbbbbbb%@",responseObjc);
            
            self.rightTableView.hidden = NO;
            
            for (NSDictionary *dic in responseObjc[@"carinfo"]) {
                
                CRCarModel *model = [CRCarModel mj_objectWithKeyValues:dic];
                
                [self.dataSource addObject:model];
                
            }
            
            [self.tableView reloadData];
            
            
            [self.rightTableView reloadData];
            
            if (self.dataSource.count == 0) {
                [self.carTypeHeadView reloadViewWithStr:@"暂无"];
            }
            
            //    通常写在viewWillAppear里面或者在[tableView reloaData]之后
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }
        else {
            
            NSInteger code = codeErr.code;
            
            if (code == 10 || code == 11 || code == 12) {
                [MBProgressHUD buildHudWithtitle:@"账号未登录" superView:self.view];
                //未登录
                [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
            } else {
                //服务器繁忙
//                [MBProgressHUD alertHUDInView:self.view Text:kServerError];
            }
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}

- (void)buildTableView {
    
    /** 左边的tableview */
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 70, kScreenHeight - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = ColorForRGB(0xf5f5f5);
    
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KTProductCell class]) bundle:nil] forCellReuseIdentifier:proIdentifier];
    
    self.tableView = tableView;
    
    /** 右边的tableview */
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(70, 64, kScreenWidth - 70, kScreenHeight - 64) style:UITableViewStylePlain];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rightTableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:rightTableView];
    
    CarTypeHeadView *carTypeHeadView = [CarTypeHeadView viewFromXib];
    
    rightTableView.tableHeaderView = carTypeHeadView;
    
    self.carTypeHeadView = carTypeHeadView;
    
    [rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CarTypeTableViewCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    
    self.rightTableView = rightTableView;
}

#pragma mark - tableView -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        
        return self.dataSource.count;
        
    } else {
        
        if (self.dataSource.count == 0) {
            return 0;
        }
        return self.dataSource[self.selectRow].info.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        
        KTProductCell *cell = [tableView dequeueReusableCellWithIdentifier:proIdentifier];
        
        CRCarModel *model = self.dataSource[indexPath.row];
        
           cell.titleLabel.text = model.issuedate;
        
        return cell;
        
    } else {
        
        CarTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
//            if (indexPath.row < self.dataSource.count) {
        
                CRCarDetailModel *listModel = self.dataSource[self.selectRow].info[indexPath.row];
                
                [cell reloadViewWithModel:listModel andType:self.subType];
                
                [self.carTypeHeadView reloadViewWithStr:self.dataSource[self.selectRow].issuedate];
                
                self.rightTableView.tableHeaderView = self.carTypeHeadView;
                
//            }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        
        self.selectRow = indexPath.row;

        [self.rightTableView reloadData];
        
    } else {
        
        /** 刷新数据 */
        
        CRCarDetailModel *listModel = self.dataSource[self.selectRow].info[indexPath.row];
        
        /** 有选择按钮 */
        if (self.subType == 1) {
            
            listModel.cellSelected = !listModel.cellSelected;
            
            if (listModel.cellSelected == YES) {
                
                [self.carArray addObject:listModel.carid];
                
            } else {
                
                [self.carArray removeObject:listModel.carid];
            }
            
            if (_returnCarIDBlock) {
                _returnCarIDBlock(self.carArray);
            }

            [self.rightTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            
            /** 选择单个cell */
            
            if (_singleCellBlock) {
                _singleCellBlock(listModel);
            }
            
        } 
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return 40;
    } else {
        return 80;
    }
}


@end
