//
//  CRAboutViewController.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAboutViewController.h"

@interface CRAboutViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textV;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@end

@implementation CRAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textV.editable = NO;
    
    self.bottomLabel.hidden = YES;
    
    [self setupNav];
    
    [self requeatData];
}

- (void)setupNav
{
    self.controllerName = @"关于我们";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - BarButtonItemAction
- (void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requeatData
{
    NSString *Help_Url = [self.baseUrl stringByAppendingString:@"user/law.php"];
    NSArray *arr = @[kHDUserId,self.Url_Type];
    [self showHud];
    [self.netWork asyncAFNPOST:Help_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);
        
        NSInteger code = codeErr.code;
        
//        NSArray *arr = responseObjc;
        NSDictionary *dic = responseObjc;
        
        if (!code)
        {
//            // 版本号
//            self.versionLabel.text = [NSString stringWithFormat:@"版本 %@",[dic objectForKey:@"num"]];
            // 内容
            self.textV.text = [dic objectForKey:@"url"];
            
            /*
            for (NSDictionary *dic in arr)
            {
                self.versionLabel.text = [dic objectForKey:@"num"];
                
                self.infoLabel.text = [dic objectForKey:@"url"];
            }
             */
        }
        else if (code == 25)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"暂时没有数据"];
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
