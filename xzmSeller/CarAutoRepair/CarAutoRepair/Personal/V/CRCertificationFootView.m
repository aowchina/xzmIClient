//
//  CRCertificationFootView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRCertificationFootView.h"
#import "CRCerModel.h"

@interface CRCertificationFootView ()
@property (weak, nonatomic) IBOutlet UIButton *headBtn;



@end

@implementation CRCertificationFootView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.topHeadView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.secHeadView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.thirView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.forthView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)setCerModel:(CRCerModel *)cerModel {
    
    if ([cerModel.status integerValue] == 2) {
        
        self.headBtn.userInteractionEnabled = YES;
        self.topHeadView.userInteractionEnabled = YES;
        self.secHeadView.userInteractionEnabled = YES;
        self.thirView.userInteractionEnabled = YES;
        self.forthView.userInteractionEnabled = YES;
    } else {
        
        self.headBtn.userInteractionEnabled = NO;
        self.topHeadView.userInteractionEnabled = NO;
        self.secHeadView.userInteractionEnabled = NO;
        self.thirView.userInteractionEnabled = NO;
        self.forthView.userInteractionEnabled = NO;
        
    }
    
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:cerModel.picture]];

    [self.topHeadView sd_setImageWithURL:[NSURL URLWithString:cerModel.cardfront] forState:UIControlStateNormal];
    [self.secHeadView sd_setImageWithURL:[NSURL URLWithString:cerModel.cardback] forState:UIControlStateNormal];
    [self.thirView sd_setImageWithURL:[NSURL URLWithString:cerModel.cardhand] forState:UIControlStateNormal];
    [self.forthView sd_setImageWithURL:[NSURL URLWithString:cerModel.license] forState:UIControlStateNormal];

}


#pragma mark - 个人头像
- (IBAction)headBtnAction:(UIButton *)sender
{
    if (self.footBlock)
    {
        self.footBlock(1000);
    }
}

- (IBAction)clickBtnAction:(UIButton *)sender {
    
    
    if (self.footBlock)
    {
        self.footBlock(sender.tag);
    }
    
}


@end
