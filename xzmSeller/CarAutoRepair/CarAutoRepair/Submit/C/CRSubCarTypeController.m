//
//  CRSubCarTypeController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/8.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRSubCarTypeController.h"
#import "KTProductCell.h"
#import "CRSubTypeTableViewCell.h"
#import "CRSubCarModel.h"
#import "CRSubCarDetailModel.h"
@interface CRSubCarTypeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;/** 分类 */
@property (nonatomic, strong) UITableView *rightTableView;/** 分类 */

@property (nonatomic, strong) NSMutableArray <CRSubCarModel *>*dataSource;/** 数据源 */

@property (nonatomic, assign) NSInteger selectRow;

@property (nonatomic, strong) NSMutableArray *carArray;

@end

@implementation CRSubCarTypeController

static NSString * const proIdentifier = @"productCell";

static NSString * const identifier = @"subTypeTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /** 分类 */
    [self buildTableView];
    
    [self requestData];
    
    [self setNav];
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"配件分类";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}


- (void)requestData {
    
    self.carArray = [NSMutableArray array];

    self.dataSource = [NSMutableArray array];
    
    self.selectRow = 0;
    
    NSString *typeUrl = [BaseURL stringByAppendingString:@"goods/PjType.php"];
    
    if (!self.carStr) {
        return;
    }
    
    NSArray *array = @[kHDUserId,self.carStr];
    
    [self showHud];
    
    [self.netWork asyncAFNPOST:typeUrl Param:array Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        
        if (!codeErr) {
            
            NSLog(@"bbbbbbbb%@",responseObjc);
            
            for (NSDictionary *dic in responseObjc[@"type"]) {
                
                CRSubCarModel *model = [CRSubCarModel mj_objectWithKeyValues:dic];
                
                [self.dataSource addObject:model];
                
            }
            
            [self.tableView reloadData];
            
            
            [self.rightTableView reloadData];
            
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
                [MBProgressHUD alertHUDInView:self.view Text:kServerError];
            }
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}

- (void)buildTableView {
    
    /** 左边的tableview */
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 120, kScreenHeight - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = ColorForRGB(0xf5f5f5);
    
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KTProductCell class]) bundle:nil] forCellReuseIdentifier:proIdentifier];
    
    self.tableView = tableView;
    
    /** 右边的tableview */
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(120, 64, kScreenWidth - 120, kScreenHeight - 64) style:UITableViewStylePlain];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rightTableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:rightTableView];

    [rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CRSubTypeTableViewCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    
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
        return self.dataSource[self.selectRow].child.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        
        KTProductCell *cell = [tableView dequeueReusableCellWithIdentifier:proIdentifier];
        
        CRSubCarModel *model = self.dataSource[indexPath.row];
        
        cell.titleLabel.text = model.tname;
        
        return cell;
        
    } else {
        
        CRSubTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
//        if (indexPath.row <= self.dataSource.count) {
        
            CRSubCarDetailModel *listModel = self.dataSource[self.selectRow].child[indexPath.row];
            
            [cell reloadViewWithModel:listModel];
            
//        }
        
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
        //    CarTypeTableViewCell *cell = [self.rightTableView cellForRowAtIndexPath:indexPath];
        /*
        CRSubCarDetailModel *listModel = self.dataSource[self.selectRow].info[indexPath.row];
        
        listModel.cellSelected = !listModel.cellSelected;
        
        if (listModel.cellSelected == YES) {
            
            [self.carArray addObject:listModel.carid];
            
        } else {
            
            [self.carArray removeObject:listModel.carid];
        }
        */
        
        CRSubCarDetailModel *listModel = self.dataSource[self.selectRow].child[indexPath.row];
        
        CRSubCarModel *model = self.dataSource[self.selectRow];
        
        if (_returnTypeBlock) {
            _returnTypeBlock(listModel.name,listModel.iD,model.typeiD);
        }
        
        [self leftBarButtonItemAction];
        
        //[self.rightTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
