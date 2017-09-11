//
//  CRGetMoneyView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/20.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRGetMoneyView.h"

@interface CRGetMoneyView ()

@property (weak, nonatomic) IBOutlet UIView *accountBackView;
@property (weak, nonatomic) IBOutlet UITextField *accTextF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextF;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightMargin;

@end

@implementation CRGetMoneyView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnAction)];
    [self.backView addGestureRecognizer:tap];
    
    
}

- (void)setTixianType:(tixianType)tixianType {
    
    if (tixianType == wechatType) {

        self.heightMargin.constant = 0;
        
    } else {
        
        self.heightMargin.constant = 55;
    }
    
}

- (IBAction)sureBtnAction {
    [self removeFromSuperview];
    
    [self.moneyTextF resignFirstResponder];
    
    if (_getMoneyBlock) {
        _getMoneyBlock(self.accTextF.text,self.moneyTextF.text);
    }

}

- (IBAction)cancelBtnAction {
    
    [self removeFromSuperview];
    
    [self.moneyTextF resignFirstResponder];
}

@end
