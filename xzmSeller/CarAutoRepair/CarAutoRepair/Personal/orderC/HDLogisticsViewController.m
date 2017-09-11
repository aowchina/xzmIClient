//
//  HDLogisticsViewController.m
//  HengDuWS
//
//  Created by minfo019 on 16/7/8.
//  Copyright © 2016年 北京银河盛泰科技有限公司. All rights reserved.
//

#import "HDLogisticsViewController.h"
#import "HDLogisticsCell.h"
#import "CRWuliuModel.h"

@interface HDLogisticsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UILabel *yundanLabel;

@property (weak, nonatomic) IBOutlet UILabel *wu_nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *wuliuLabel;

@end

@implementation HDLogisticsViewController

static NSString *cellIdentify = @"HDLogisticsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    [self requestData];
    
    [self setupNav];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDLogisticsCell class]) bundle:nil] forCellReuseIdentifier:cellIdentify];
}

- (void)setupNav
{
    self.controllerName = @"物流信息";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - BarButtonItemAction
- (void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求查看物流数据
- (void)requestData
{
    NSString *Check_Url = self.orderType == 1 ? [self.baseUrl stringByAppendingString:@"order/SeeWl.php"] : [self.baseUrl stringByAppendingString:@"qgorder/SeeWl.php"];
    NSArray *arr = @[kHDUserId,self.order_id];
    [self showHud];
    [self.netWork asyncAFNPOST:Check_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        
        NSLog(@"%@",responseObjc);
        NSInteger code = codeErr.code;
        
        if (!codeErr)
        {
            
            if ([responseObjc[@"list"] isKindOfClass:[NSString class]]) {
                
                self.wu_nameLabel.text = @"暂无物流信息";
                
            } else {
                NSArray *array = responseObjc[@"list"][@"data"];
                
                if (array.count == 0) {
                    
                    self.wu_nameLabel.text = @"暂无物流信息";
                    
                } else {
                    
                    array = [array reverseObjectEnumerator].allObjects;
                    
                    self.wu_nameLabel.text = self.wuliuType;
                    self.yundanLabel.text = self.yundanNum;
                    
                    for (NSDictionary *dic in array) {
                        
                        CRWuliuModel *model = [CRWuliuModel mj_objectWithKeyValues:dic];
                        
                        [self.dataSource addObject:model];
                        
                    }
                    
                    [self.tableView reloadData];
                    
                }
                
                
            }
        }
        else if (code == 11)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"账号异常，请重新登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else if (code == 12)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"用户未登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD buildHudWithtitle:@"无法连接到网络，请稍后再试!" superView:self.view];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (indexPath.row < self.dataSource.count) {
        
        CRWuliuModel *model = self.dataSource[indexPath.row];
        
        cell.timeLabel.text = model.context;
        cell.addressLabel.text = model.time;
        
        //        if (![str isEqualToString:@""]) {
        //            cell.addressLabel.text = str;
        //
        //        }
        //
        //        cell.timeLabel.text = addressStr;
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 32;
    if (indexPath.row < self.dataSource.count) {
        //        NSString *str = self.dataSource[indexPath.row][@"AcceptStation"];
        CRWuliuModel *model = self.dataSource[indexPath.row];
        
        NSString *addressStr = model.context;
        height += [SuperHelper stringHeight:addressStr containedSie:CGSizeMake(kScreenWidth - 72, FLT_MAX) labelFont:[UIFont systemFontOfSize:14.0f]];
        
    }
    return height;
}



@end
