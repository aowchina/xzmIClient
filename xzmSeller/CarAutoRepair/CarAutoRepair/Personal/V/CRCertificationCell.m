//
//  CRCertificationCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRCertificationCell.h"
#import "CRCerModel.h"

@implementation CRCertificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    [self.detailTextF addTarget:self action:@selector(textfieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)reloadDataWithModel:(CRCerModel *)model andIndex:(NSInteger)index {

    if ([model.status integerValue] == 1 || [model.status integerValue] == 0) {
        
        self.detailTextF.userInteractionEnabled = NO;
        
    } else {
        
        self.detailTextF.userInteractionEnabled = YES;
    }
    
    if (index == 2) {
        self.detailTextF.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if (index == 3) {
        self.detailTextF.userInteractionEnabled = NO;
    }
    
//    if (<#condition#>) {
//        <#statements#>
//    }
//    
    switch (index) {
        case 0:
            self.detailTextF.text = model.company;
            break;
        case 1:
            self.detailTextF.text = model.sname;
            break;
        case 2:
            self.detailTextF.text = model.number;
            break;
        case 3:
            self.detailTextF.text = model.address;
            break;
        case 4:
            self.detailTextF.text = model.major;
            break;
        case 5:
            self.detailTextF.text = model.skill;
            break;
        default:
            break;
    }
    
}


- (void)textfieldTextDidChange:(UITextField *)textField
{
    self.block(self.detailTextF.text);
}
@end
