//
//  CRAccessoriesSearchController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAccessoriesSearchController.h"
#import "CRSearchTableViewCell.h"
#import "SearchTextField.h"
#import "CROEMSearchModel.h"

#import "CRProDeatilController.h"

@interface CRAccessoriesSearchController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) SearchTextField *searchTextF;


@end

@implementation CRAccessoriesSearchController

static NSString * const idenyifier = @"CRSearchTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    
    [self buildSearchBar];
    
    [self createTableView];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = kColor(234, 234, 236);
    /** 去tableview的线 */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    self.tableView.tableHeaderView = self.loopScrollView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CRSearchTableViewCell" bundle:nil] forCellReuseIdentifier:idenyifier];
}

- (void)buildSearchBar {
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    /** 右按钮 */
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItem initWithTitle:@"查询" titleColor:ColorForRGB(0x828282) target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    /** 搜索框 */
    self.searchTextF = [[SearchTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth *0.65, kScreenWidth * 0.08)];
    
    self.searchTextF.background = kImage(@"qixiu_sousuokuang");
    
    self.searchTextF.placeholder = @"查询";
    
    self.searchTextF.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.searchTextF.leftView = [[UIImageView alloc] initWithImage:kImage(@"qixiu_sousuo")];
    
    self.searchTextF.leftViewMode = UITextFieldViewModeAlways;
    
    self.searchTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.searchTextF.font = [UIFont systemFontOfSize:13.0f];
    
    self.navigationItem.titleView = self.searchTextF;
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenyifier forIndexPath:indexPath];
    
    if (indexPath.row < self.dataSource.count)
    {
        CROEMSearchModel *model =self.dataSource[indexPath.row];
        
        cell.model = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenHeight * 0.20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CROEMSearchModel *model =self.dataSource[indexPath.row];
    
    CRProDeatilController *detailVC = [[CRProDeatilController alloc] init];
    detailVC.goodid = model.goodid;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma makr - 搜索(配件查询|OEM查询)
- (void)rightBarButtonItemAction
{
    
    self.dataSource = [NSMutableArray array];
    
    NSString *Url_Str = [NSString string];
    NSArray *arr = [NSArray array];
    
    if (self.pushType == AccessoriesViewControllerType)
    {
        // 配件查询
        NSString *Accessories_Url = [self.baseUrl stringByAppendingString:@"cha/Pjian.php"];
        
        Url_Str = Accessories_Url;
        
        NSArray *arr1 = @[kHDUserId,[SuperHelper changeStringUTF:self.searchTextF.text]];
        arr = arr1;
    }
    else
    {
        // OEM查询
        NSString *OEM_Url = [self.baseUrl stringByAppendingString:@"cha/Oem.php"];
        
        Url_Str = OEM_Url;
        
        NSArray *arr1 = @[kHDUserId,self.searchTextF.text];
        arr = arr1;
    }
    
    [self showHud];
    [self.netWork asyncAFNPOST:Url_Str Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            for (NSDictionary *dic in responseObjc)
            {
                CROEMSearchModel *model = [CROEMSearchModel mj_objectWithKeyValues:dic];
                
                [self.dataSource addObject:model];
            }
            
            [self.tableView reloadData];
        }
        else if (code == 12)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"用户未登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else if (code == 15)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请输入查询号"];
        }
        else if (code == 16)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"此OEM号的商品暂未上架"];
        }
        else if (code == 17)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请输入配件名"];
        }
        else if (code == 18)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"此配件暂未上架"];
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}



@end
