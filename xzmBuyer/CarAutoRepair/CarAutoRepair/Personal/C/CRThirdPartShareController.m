//
//  CRThirdPartShareController.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/13.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRThirdPartShareController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"

@interface CRThirdPartShareController ()

@property (strong, nonatomic) IBOutlet UIView *maskView;

@property (weak, nonatomic) IBOutlet UIView *whiteView;

@end

@implementation CRThirdPartShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _whiteView.layer.cornerRadius = 5;
    _whiteView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackViewTap)];
    [self.maskView addGestureRecognizer:backViewTap];
}

#pragma mark - 分享
- (IBAction)shareClick:(UIButton *)btn
{
    NSInteger SSDKPlatformType;
    
    NSArray* imageArray = @[[UIImage imageNamed:@"CRPlaceholderImage"]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"心之盟下载链接...."
                                         images:imageArray
                                            url:[NSURL URLWithString:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1270614060"]
                                          title:@""
                                           type:SSDKContentTypeAuto];
        
        [shareParams SSDKEnableUseClientShare];
        
        if (btn.tag == 100)
        {
            SSDKPlatformType = SSDKPlatformSubTypeWechatSession;   // 微信好友
        }
        else
        {
            SSDKPlatformType = SSDKPlatformSubTypeWechatTimeline;  // 微信朋友圈
        }
        
        [ShareSDK share:SSDKPlatformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [self clickBackViewTap];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:@"请稍后重试"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
            
        }];
    }
  
}


- (void)clickBackViewTap {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
