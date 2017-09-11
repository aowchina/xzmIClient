//
//  CRCarSearchView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRCarSearchView.h"
#import "SearchTextField.h"

@implementation CRCarSearchView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.searchTexfF.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.searchTexfF.leftView = [[UIImageView alloc] initWithImage:kImage(@"qixiu_sousuo")];
    
    self.searchTexfF.leftViewMode = UITextFieldViewModeAlways;
    
}

- (IBAction)searchBtnAction:(UIButton *)sender {
    
    if (self.searchBlock)
    {
        self.searchBlock();
    }
}

@end
