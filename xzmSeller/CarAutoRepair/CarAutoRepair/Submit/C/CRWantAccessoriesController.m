//
//  CRWantAccessoriesController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRWantAccessoriesController.h"
#import "CRAccessoriesSubmmitController.h"
#import "CRPeijianWantController.h"

@interface CRWantAccessoriesController ()


@property (weak, nonatomic) IBOutlet UIButton *headImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation CRWantAccessoriesController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftBarButtonItemAction) name:@"popNoti" object:nil];
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"配件求购";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (IBAction)headImageBtnAction:(UIButton *)sender {
    
    
    
}

- (IBAction)handChooseBtnAction:(UIButton *)sender {
    
    
    CRAccessoriesSubmmitController *accessoriesSubmmitC = [[CRAccessoriesSubmmitController alloc] init];
    accessoriesSubmmitC.popType = self.popType;
    [self.navigationController pushViewController:accessoriesSubmmitC animated:YES];
}

- (IBAction)vinNumBtnAction:(UIButton *)sender {

    CRPeijianWantController *accessoriesSubmmitC = [[CRPeijianWantController alloc] init];
    [self.navigationController pushViewController:accessoriesSubmmitC animated:YES];
}

- (void)leftBarButtonItemAction {
    
    if (self.popType == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
     
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
