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
#import "CROrderListVC.h"

@interface CRPublishedEvaluationVC ()<MBProgressHUDDelegate>
/** 小图 */
@property (weak, nonatomic) IBOutlet UIImageView *smallImgView;
/** 描述状态 */
@property (nonatomic ,strong) UILabel *describeLabel;
/** 描述分值 */
@property (nonatomic ,strong) NSString *describe;
/** 评论内容 */
@property (weak, nonatomic) IBOutlet UITextView *evaluationTextF;
/** 物流分值 */
@property (nonatomic ,strong) NSString *wuliuState;
/** 服务分值 */
@property (nonatomic ,strong) NSString *serviceState;


@end

@implementation CRPublishedEvaluationVC

static NSInteger starsNum = 5;  // 星星数量

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    
    _evaluationTextF.placeholder = @"输入你想评价的内容";
   
    [self creatDescribeStarView];
    
    _describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 95, 30, 17)];
    _describeLabel.font = [UIFont systemFontOfSize:14];
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

    NSString *AddEvaluation_Url = [self.baseUrl stringByAppendingString:@"user/addPinjia.php"];
    NSArray *arr = @[kHDUserId,self.goodID,_describe,_wuliuState,_serviceState,[SuperHelper changeStringUTF:_evaluationTextF.text],self.orderID];
    [self showHud];
    [self.netWork asyncAFNPOST:AddEvaluation_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSLog(@"%@",responseObjc);

        NSInteger code = codeErr.code;
        
        if (!code)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"发表评价成功"Delegate:self];
        }
        else if (code == 11)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"账号异常，请重新登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else if (code == 12)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"用户未登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
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

#pragma mark - 描述相关星星
- (void)creatDescribeStarView
{
    XHStarRateView *firstView = [[XHStarRateView alloc] initWithFrame:CGRectMake(140, 95, 130, 14) numberOfStars:starsNum rateStyle:WholeStar isAnination:YES finish:^(CGFloat currentScore) {
        
        _describe = @(currentScore).stringValue;
        
        switch ((int)currentScore)
        {
            case 1:
                _describeLabel.text = @"差评";
                _describeLabel.textColor = [UIColor blackColor];
                break;
            case 2:
                _describeLabel.text = @"勉强";
                _describeLabel.textColor = [UIColor redColor];
                break;
            case 3:
                _describeLabel.text = @"一般";
                _describeLabel.textColor = [UIColor redColor];
                break;
            case 4:
                _describeLabel.text = @"很好";
                _describeLabel.textColor = [UIColor redColor];
                break;
            case 5:
                _describeLabel.text = @"好评";
                _describeLabel.textColor = [UIColor redColor];
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
    XHStarRateView *secondView = [[XHStarRateView alloc] initWithFrame:CGRectMake(92, 390, 130, 14) numberOfStars:starsNum rateStyle:WholeStar isAnination:YES finish:^(CGFloat currentScore) {
        
        _wuliuState = @(currentScore).stringValue;
    }];
    
    [self.view addSubview:secondView];
}

#pragma mark - 服务星星
- (void)creatServiceStarView
{
    XHStarRateView *thirdView = [[XHStarRateView alloc] initWithFrame:CGRectMake(92, 435, 130, 14) numberOfStars:starsNum rateStyle:WholeStar isAnination:YES finish:^(CGFloat currentScore) {
        
        _serviceState = @(currentScore).stringValue;
    }];
    
    [self.view addSubview:thirdView];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
//    [self.navigationController popViewControllerAnimated:YES];
    
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[CROrderListVC class]]) {
            CROrderListVC *orderVC =(CROrderListVC *)controller;
            [self.navigationController popToViewController:orderVC animated:YES];
        }
    }
}


@end
