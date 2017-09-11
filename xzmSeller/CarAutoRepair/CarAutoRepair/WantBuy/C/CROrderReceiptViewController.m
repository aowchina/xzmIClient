//
//  CROrderReceiptViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/2.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CROrderReceiptViewController.h"
#import "CROrderReHeadView.h"
#import "UITextView+YLTextView.h"
#import "TracyPicCollectionView.h"

@interface CROrderReceiptViewController ()

@property (weak, nonatomic) IBOutlet UIView *headBackView;
/** 头视图 */
@property (weak, nonatomic) IBOutlet UIView *ORHeadView;

@property (weak, nonatomic) IBOutlet UITextField *receiptMoneyTextF;

@property (weak, nonatomic) IBOutlet UITextView *orderDetailTextF;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;

@property (nonatomic, strong) TracyPicCollectionView *picCollectionView;

@end

@implementation CROrderReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setNav];
    [self buildHeadView];
    
    self.orderDetailTextF.placeholder = @"选填，填写的内容是交易的凭证。";
}

- (void)buildHeadView {
    
    CROrderReHeadView *orHeadView = [CROrderReHeadView viewFromXib];
    
    orHeadView.frame = self.ORHeadView.bounds;
    
    [self.ORHeadView addSubview:orHeadView];
    
    self.picCollectionView = [[TracyPicCollectionView alloc] initWithFrame:CGRectMake(0, self.headBackView.height + 65, kScreenWidth, kScreenHeight - 49 - self.headBackView.height - 65)];
    [self.view addSubview:self.picCollectionView];
    
    
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"开单收款";
    /** 右按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (IBAction)makeSureBtnAction:(UIButton *)sender {
    
    NSLog(@"确定支付");
    
    NSDictionary *dic = @{@"extType":@"orderInfo",@"infoId":@"10086",@"name":@"奔驰",@"icon":@"www",@"price":self.receiptMoneyTextF.text,@"carType":@"奔驰A"};
    
    if (_makeOfferBlock) {
        _makeOfferBlock(dic);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
