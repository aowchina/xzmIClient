//
//  CRPublishedEvaluationVC.m
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/6.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRPublishedEvaluationVC.h"
#import "UITextView+YLTextView.h"
#import "XHStarRateView.h"

@interface CRPublishedEvaluationVC ()
/** 小图 */
@property (weak, nonatomic) IBOutlet UIImageView *smallImgView;
/** 描述状态 */
@property (nonatomic ,strong) UILabel *describeLabel;
/** 评论内容 */
@property (weak, nonatomic) IBOutlet UITextView *evaluationTextF;
/** 物流状态 */
@property (nonatomic ,strong) NSString *wuliuState;
/** 服务状态 */
@property (nonatomic ,strong) NSString *serviceState;


@end

@implementation CRPublishedEvaluationVC

static NSInteger starsNum = 5;  // 星星数量

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    
    _evaluationTextF.placeholder = @"输入你想评价的内容";
    _evaluationTextF.limitLength = @300;
   
    [self creatDescribeStarView];
    
    _describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(295, 95, 30, 17)];
    [self.view addSubview:_describeLabel];
    
    [self creatWuLiuStarView];
    
    [self creatServiceStarView];
}

- (void)setupNav
{
    self.controllerName = @"发表评价";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItem initWithTitle:@"发布" titleColor:kColor(199, 0, 0) target:self action:@selector(rightBarButtonIremAction)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

#pragma mark - BarButtonItemAction
- (void)leftBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发布点击
- (void)rightBarButtonIremAction
{
    if (_describeLabel.text.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"您未评价描述"];
        return;
    }
    if (_evaluationTextF.text.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"您未填写评价的内容"];
        return;
    }
    if (_wuliuState.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"您未评价物流"];
        return;
    }
    if (_serviceState.length == 0)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"您未评价服务"];
        return;
    }
    NSLog(@"发布");
    /*
    [self showHud];
    [self.netWork asyncAFNPOST:@"" Param:@[] Success:^(id responseObjc, NSError *codeErr) {
        [self ednHud];
        
    } Failure:^(NSError *netErr) {
        
        
    }];
     */
}

#pragma mark - 描述相关星星
- (void)creatDescribeStarView
{
    XHStarRateView *firstView = [[XHStarRateView alloc] initWithFrame:CGRectMake(140, 95, 150, 14) numberOfStars:starsNum rateStyle:WholeStar isAnination:YES finish:^(CGFloat currentScore) {
        
        switch ((int)currentScore)
        {
            case 1:
                _describeLabel.text = @"1";
                break;
            case 2:
                _describeLabel.text = @"2";
                break;
            case 3:
                _describeLabel.text = @"3";
                break;
            case 4:
                _describeLabel.text = @"4";
                break;
            case 5:
                _describeLabel.text = @"5";
                break;
                
            default:
                break;
        }

    }];
    [self.view addSubview:firstView];
}

#pragma mark - 物流星星
- (void)creatWuLiuStarView
{
    XHStarRateView *secondView = [[XHStarRateView alloc] initWithFrame:CGRectMake(92, 390, 150, 14) numberOfStars:starsNum rateStyle:WholeStar isAnination:YES finish:^(CGFloat currentScore) {
        
        _wuliuState = @(currentScore).stringValue;
        NSString *str = [NSString stringWithFormat:@"物流评分%@",_wuliuState];
        [MBProgressHUD alertHUDInView:self.view Text:str];
        
    }];
    
    [self.view addSubview:secondView];
}

#pragma mark - 服务星星
- (void)creatServiceStarView
{
    XHStarRateView *thirdView = [[XHStarRateView alloc] initWithFrame:CGRectMake(92, 435, 150, 14) numberOfStars:starsNum rateStyle:WholeStar isAnination:YES finish:^(CGFloat currentScore) {
        
        _serviceState = @(currentScore).stringValue;
        NSString *str = [NSString stringWithFormat:@"服务评分%@",_serviceState];
        [MBProgressHUD alertHUDInView:self.view Text:str];
        
    }];
    
    [self.view addSubview:thirdView];
}

@end
