//
//  CRProChooseNumView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/20.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRProChooseNumView.h"

@interface CRProChooseNumView ()



@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, assign) NSInteger count;

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation CRProChooseNumView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.count = 1;
    
    /** 添加手势 */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnAction:)];
    
    [self.backView addGestureRecognizer:tap];
    
}

- (IBAction)minusBtnAction:(UIButton *)sender {
    
    self.count--;
    
    if (self.count <= 1) {
        self.count = 1;
    }
    
    self.countLabel.text = @(self.count).stringValue;
    
    
}

- (IBAction)plusBtnAction:(UIButton *)sender {
    
    self.count++;
    
    if (self.count <= 1) {
        self.count = 1;
    }
    
    self.countLabel.text = @(self.count).stringValue;
}

- (IBAction)cancelBtnAction:(id)sender {
    
    self.hidden = YES;
}


- (IBAction)sureBtnAction:(UIButton *)sender {
    
    self.hidden = YES;
    
    if (_clickMakeSureBlock) {
        
        _clickMakeSureBlock(self.countLabel.text);
    }
    
}

@end
