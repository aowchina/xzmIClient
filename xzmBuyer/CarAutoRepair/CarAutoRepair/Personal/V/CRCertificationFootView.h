//
//  CRCertificationFootView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^footBlock)(NSInteger);

@interface CRCertificationFootView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImageV;

@property (weak, nonatomic) IBOutlet UIButton *topHeadView;
@property (weak, nonatomic) IBOutlet UIButton *secHeadView;
@property (weak, nonatomic) IBOutlet UIButton *thirView;
@property (weak, nonatomic) IBOutlet UIButton *forthView;

@property (nonatomic ,strong) footBlock footBlock;

@end
