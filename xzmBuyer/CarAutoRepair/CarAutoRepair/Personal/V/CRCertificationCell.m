//
//  CRCertificationCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRCertificationCell.h"

@implementation CRCertificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    [self.detailTextF addTarget:self action:@selector(textfieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
}

/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.detailTextF becomeFirstResponder];
}
 */


- (void)textfieldTextDidChange:(UITextField *)textField
{
    self.block(self.detailTextF.text);
}
@end
