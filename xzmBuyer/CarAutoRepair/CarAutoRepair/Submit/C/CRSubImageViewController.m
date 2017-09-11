//
//  CRSubImageViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/8.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRSubImageViewController.h"
#import "TracyPicCollectionView.h"

@interface CRSubImageViewController ()

@property (nonatomic, strong) TracyPicCollectionView *picCollectionView;

@end

@implementation CRSubImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];

    [self createCollectView];
    [self createBottomView];
}

- (void)createCollectView {
    
    self.picCollectionView = [[TracyPicCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    self.picCollectionView.editType = self.editType;
    self.picCollectionView.editArray = self.editArray;
    
    self.picCollectionView.imageArr = self.imageArr;
//    self.picCollectionView.imageDataAry = self.imageDataAry;
    
    [self.view addSubview:self.picCollectionView];
}

- (void)setNav {
    
    /** 设置标题 */
    self.controllerName = @"上传图片";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)createBottomView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    btn.titleLabel.font = KFont(16);
    [btn setTitle:@"上传图片" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBottomBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:kImage(@"bgbtnqixiu_quedingkuang") forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)clickBottomBtn {
    
    //NSLog(@"%@---%@",self.picCollectionView.imageArr,self.picCollectionView.imageDataAry);
    
    if (_returnImageBlock) {
        _returnImageBlock(self.picCollectionView.imageArr,nil,self.picCollectionView.deleteArray);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
