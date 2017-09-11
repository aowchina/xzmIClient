//
//  CRProSecHeaderView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/22.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRProSecHeaderView.h"

@interface CRProSecHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *allProLabel;

@property (weak, nonatomic) IBOutlet UILabel *neProLabel;

@property (weak, nonatomic) IBOutlet UIView *leftProView;

@property (weak, nonatomic) IBOutlet UIView *rightProView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHeightMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightHeightMargin;

@end

@implementation CRProSecHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (IBAction)leftBtnAction:(UIButton *)sender {
    
    [self setLeftViewColor];

    if (self.leftBlock)
    {
        self.leftBlock();
    }
}

- (IBAction)rightBtnAction:(UIButton *)sender {
    
    [self setRightViewColor];
    
    if (self.rightBlock)
    {
        self.rightBlock();
    }
}

/** 设置颜色 */
- (void)setLeftViewColor {
    
    self.leftProView.backgroundColor = self.allAmountLabel.textColor = self.allProLabel.textColor = ColorForRGB(0xc80000);
    self.neAmountLabel.textColor = self.neProLabel.textColor = ColorForRGB(0x000000);
    self.rightProView.backgroundColor = ColorForRGB(0x828282);
    self.leftHeightMargin.constant = 2.5;
    self.rightHeightMargin.constant = 1;
}

- (void)setRightViewColor {

    self.allAmountLabel.textColor = self.allProLabel.textColor = ColorForRGB(0x000000);
    self.rightProView.backgroundColor = self.neAmountLabel.textColor = self.neProLabel.textColor = ColorForRGB(0xc80000);
    self.leftProView.backgroundColor = ColorForRGB(0x828282);
    self.leftHeightMargin.constant = 1;
    self.rightHeightMargin.constant = 2.5;
}

@end
