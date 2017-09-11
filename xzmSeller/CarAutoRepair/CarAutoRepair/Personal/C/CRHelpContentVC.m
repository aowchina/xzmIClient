//
//  CRHelpContentVC.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/21.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRHelpContentVC.h"

@interface CRHelpContentVC ()
@property (weak, nonatomic) IBOutlet UITextView *textV;

@property (weak, nonatomic) IBOutlet UILabel *tiLabel;

@end

@implementation CRHelpContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    self.tiLabel.text = self.title;
    
    self.textV.text = self.contentStr;
    
    self.textV.editable = NO;
    
}

- (void)setupNav
{
    self.controllerName = @"帮助详情";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
