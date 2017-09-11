//
//  CRAccessoriesSubmitView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAccessoriesSubmitView.h"
#import "UITextView+YLTextView.h"

#import "CRSubCarDetailModel.h"

@interface CRAccessoriesSubmitView ()

//@property (weak, nonatomic) IBOutlet UIView *headView;



@property (weak, nonatomic) IBOutlet UIView *brandLimitView;

@property (weak, nonatomic) IBOutlet UIView *otherLimitView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandHeightMargin;

@property (weak, nonatomic) IBOutlet UIButton *oldChanBtn;

@property (weak, nonatomic) IBOutlet UIButton *chaiCheBtn;

@property (weak, nonatomic) IBOutlet UIButton *brand_btn;

@property (weak, nonatomic) IBOutlet UIButton *other_Btn;

//@property (weak, nonatomic) IBOutlet UITextView *assPeijianTextV;

@end

@implementation CRAccessoriesSubmitView

- (void)awakeFromNib {
    [super awakeFromNib];
        
//    self.assPeijianTextV.placeholder = @"配件名称，多种配件请用空格分开";
    
}

- (void)setModel:(CRSubCarDetailModel *)model {
    
    self.vinTextF.text = model.vin;
    self.assPeijianTextV.text = model.jname;
    
    NSLog(@"--a%@   \n--%@",model.pinpai,model.otherpz);
    self.limitTextF.text = [NSString stringWithFormat:@"%@ ",model.pinpai];
    self.otherBrandTextF.text = [NSString stringWithFormat:@"%@ ",model.otherpz];
    
    NSArray *array = model.type;
    
    for (NSString *str in array) {
        
        if ([str isEqualToString:@"0"]) {
            
            self.oldChanBtn.selected = YES;
            
        } else if ([str isEqualToString:@"1"]) {
            
            self.chaiCheBtn.selected = YES;
            
        } else if ([str isEqualToString:@"2"]) {
            
            self.brand_btn.selected = YES;
            
        } else if ([str isEqualToString:@"3"]) {
            
            self.other_Btn.selected = YES;
            
        }
        
        if ([array containsObject:@"2"]) {
            
            self.brandLimitView.hidden = NO;
            self.brandHeightMargin.constant = 35;
        } else {
            self.brandLimitView.hidden = YES;
            self.brandHeightMargin.constant = 0;
        }
        
    }
    
    self.vinTextF.userInteractionEnabled = NO;
    self.assPeijianTextV.userInteractionEnabled = NO;
    self.limitTextF.userInteractionEnabled = NO;
    self.otherBrandTextF.userInteractionEnabled = NO;
    self.oldChanBtn.userInteractionEnabled = NO;
    self.chaiCheBtn.userInteractionEnabled = NO;
    self.brand_btn.userInteractionEnabled = NO;
    self.other_Btn.userInteractionEnabled = NO;
    
}

- (IBAction)oldCBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (_changOldBlock) {
        _changOldBlock(sender);
    }
}

- (IBAction)chaiCheBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (_changUIBlock) {
        _changUIBlock(sender);
    }
    
}

- (IBAction)brandBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
        
        self.brandLimitView.hidden = NO;
        self.brandHeightMargin.constant = 35;
    } else {
        self.brandLimitView.hidden = YES;
        self.brandHeightMargin.constant = 0;
    }
    
    if (_brand_BtnBlock) {
        _brand_BtnBlock(sender);
    }
    
}

- (IBAction)otherBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
        
        if (self.brand_btn.selected == YES) {
            
            self.brandLimitView.hidden = NO;
            self.brandHeightMargin.constant = 35;
        } else {
            self.brandLimitView.hidden = YES;
            self.brandHeightMargin.constant = 0;
        }
    } else {
        self.brandLimitView.hidden = NO;
        self.brandHeightMargin.constant = 35;
    }
    
    if (_other_BtnBlock) {
        _other_BtnBlock(sender);
    }
}

@end
