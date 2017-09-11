//
//  CRWebViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/27.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRWebViewController.h"

@interface CRWebViewController () <UIWebViewDelegate> {
    
    UIActivityIndicatorView *activity;
}

@end

@implementation CRWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNav];
    
    [self createWebView];
}

- (void)setNav {
    
    /** 设置标题 */
    self.controllerName = self.name;
    
    /** 右按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)createWebView {
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    webView.backgroundColor = [UIColor clearColor];
    webView.scalesPageToFit =YES;
    webView.delegate =self;
    
    
    
    NSURL *url = [[NSURL alloc]initWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showHud];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self endHud];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求不成功，请查看网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
