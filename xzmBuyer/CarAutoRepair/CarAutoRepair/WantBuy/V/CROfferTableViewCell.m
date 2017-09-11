//
//  CROfferTableViewCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/2.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CROfferTableViewCell.h"
#import "CROfferModel.h"

@interface CROfferTableViewCell ()<UITextFieldDelegate>



@property (weak, nonatomic) IBOutlet UIButton *cell_btn;

//@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

//@property (weak, nonatomic) IBOutlet UILabel *midMoneyLabel;


@end

@implementation CROfferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.midTextF.delegate = self;
}

- (IBAction)chooseBtnAction:(UIButton *)sender {
    
//    sender.selected = !sender.selected;
    
    if (_priceBlock) {
        
        _priceBlock(sender,self);
    }
}

- (void)reloadDataWithModel:(CROfferModel *)model andPushType:(NSInteger)type {
    
    if (type == 1) {
        
        self.midTextF.userInteractionEnabled = NO;
        
        if ([model.price isEqualToString:@""]) {
            
            self.midTextF.text = @" ";
            self.cell_btn.hidden = YES;
        } else {
            
            self.cell_btn.hidden = NO;
            self.midTextF.text = model.price;
        }
        
        self.leftLabel.text = model.name;
        self.cell_btn.selected = model.btn_selected;
        
    } else {
        
        self.leftLabel.text = model.name;
        self.midTextF.text = model.price;
        self.cell_btn.selected = model.btn_selected;
    }
    
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (_textChangeBlock) {
        
        _textChangeBlock(self.midTextF.text);
    }
    
    return YES;
    
}

@end
