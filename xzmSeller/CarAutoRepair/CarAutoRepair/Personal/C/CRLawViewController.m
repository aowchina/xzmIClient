//
//  CRLawViewController.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRLawViewController.h"


@interface CRLawViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic ,strong) NSString *infoStr;

@end

@implementation CRLawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    [self requestData];
    
    self.bgScrollView.scrollEnabled = NO;
}

- (void)requestData
{
    NSString *Law_Url = [self.baseUrl stringByAppendingString:@"user/law.php"];
    NSArray *arr = @[kHDUserId,self.Url_Type];
    [self showHud];
    [self.netWork asyncAFNPOST:Law_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSDictionary *dic = responseObjc;

        NSInteger code = codeErr.code;
        
        if (!code)
        {
            self.infoStr = [dic objectForKey:@"url"];
            [self setUpView];
        }
        else if (code == 24)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"法律声明暂时没有数据"];
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

- (void)setupNav
{
    self.controllerName = @"法律声明";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

#pragma mark - BarButtonItemAction
- (void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)setUpView
{
    self.infoLabel.text = self.infoStr;
    
    self.infoLabel.numberOfLines = 0;

    self.infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    //获取文字高度
    [self.infoLabel sizeToFit];
    
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth, self.infoLabel.frame.size.height + 20);
    
}

@end
