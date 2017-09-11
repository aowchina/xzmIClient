//
//  CRSubmitView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRSubmitView.h"
#import "CRLoginController.h"

@interface CRSubmitView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation CRSubmitView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBgViewAction)];
    [self.bgView addGestureRecognizer:tap];
    
}

- (IBAction)salePeijianAction:(UIButton *)sender {
    
    [self removeFromSuperview];
    

    if (_clickPeijianBlock) {
        _clickPeijianBlock(1000);
    }
}

- (IBAction)wantPeijianAction:(UIButton *)sender {
 
    [self removeFromSuperview];
    
    if (_clickPeijianBlock) {
        _clickPeijianBlock(1001);
    }
}

- (void)clickBgViewAction {
    
    [self removeFromSuperview];
}

@end
