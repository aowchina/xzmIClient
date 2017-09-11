//
//  CRPersonalHeaderView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRPersonalHeaderView.h"



@interface CRPersonalHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *waitpay_btn;
@property (weak, nonatomic) IBOutlet UIButton *fahuo_btn;
@property (weak, nonatomic) IBOutlet UIButton *shouh_btn;
@property (weak, nonatomic) IBOutlet UIButton *pingjia_btn;


@end

@implementation CRPersonalHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (kScreenWidth > 320) {
        self.waitpay_btn.imageEdgeInsets = UIEdgeInsetsMake( - 20, 25, 0, 0);
        self.fahuo_btn.imageEdgeInsets = UIEdgeInsetsMake( - 20, 28, 0, 0);
        self.shouh_btn.imageEdgeInsets = UIEdgeInsetsMake( - 20, 30, 0, 0);
        self.pingjia_btn.imageEdgeInsets = UIEdgeInsetsMake( - 20, 28, 0, 0);
    }
}

- (IBAction)clickSettingBtnAction:(UIButton *)sender {
    
    if (_clickSettingBtnBlock) {
        
        _clickSettingBtnBlock();
    }
    
}

- (IBAction)clickBtnAction:(UIButton *)sender {
    
    if (_clickOrderBtnBlock) {
        
        _clickOrderBtnBlock(sender.tag);
    }
    
    
}


@end
