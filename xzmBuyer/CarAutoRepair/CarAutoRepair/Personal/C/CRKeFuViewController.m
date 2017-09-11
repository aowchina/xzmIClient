//
//  CRKeFuViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/7/12.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRKeFuViewController.h"
#import "CRKeFuTableViewCell.h"
#import "CRkefuModel.h"
#import "TracyCarViewController.h"

@interface CRKeFuViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation CRKeFuViewController

static NSString * const identifier = @"KeFuCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.dataArr = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setupNav];
    
    [self requestData];
}

- (void)requestData {
    
    NSString *Law_Url = [self.baseUrl stringByAppendingString:@"kefu/List.php"];
    NSArray *arr = @[kHDUserId];
    [self showHud];
    [self.netWork asyncAFNPOST:Law_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        
        NSInteger code = codeErr.code;
        
        if (!code)
        {
            NSArray *array = responseObjc;
            
            for (NSDictionary *dic in array) {
                
                CRkefuModel *model = [CRkefuModel mj_objectWithKeyValues:dic];
                
                [self.dataArr addObject:model];
            }
            
            [self.tableView reloadData];
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


- (void)setupNav {
    
    self.controllerName = @"客服";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView registerNib:[UINib nibWithNibName:@"CRKeFuTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    CRKeFuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    CRkefuModel *model = self.dataArr[indexPath.row];
    
    cell.model = model;
    
    cell.click_btnBlock = ^(UIButton *sender) {
      
        switch (sender.tag) {
                case 1000: {
                 
                    TracyCarViewController *chatController = [[TracyCarViewController alloc] initWithConversationChatter:[@"sell" stringByAppendingString:model.sellerid] conversationType:EMConversationTypeChat];
                    
                    chatController.headUrl = model.picture;
                    chatController.title = model.name;
                    
                    [self.navigationController pushViewController:chatController animated:YES];
                    
                }
                break;
                
                case 1001: {
                    
                    // 电话
                    
                    if ([SuperHelper isEmpty:model.tel]) {
                        
                        [MBProgressHUD alertHUDInView:self.view Text:@"商家暂未提供电话号码"];
                        return;
                    }
                    
                    [MBProgressHUD alertHUDInView:self.view Text:@"请稍等..."];
                    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.tel];
                    UIWebView *callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebview];

                }
                break;
                
            default:
                break;
        }
        
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
