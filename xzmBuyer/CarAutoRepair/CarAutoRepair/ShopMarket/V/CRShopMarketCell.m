//
//  CRShopMarketCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/18.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRShopMarketCell.h"
#import "CRShopMarket.h"


@interface CRShopMarketCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *baojiazLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *askBtn;

@end

@implementation CRShopMarketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)questBtnAction:(UIButton *)sender {
    
    if (_offerBlock) {
        _offerBlock(self);
    }
    
}

- (void)reloadDataWithModel:(CRShopMarket *)model andTypeStr:(NSString *)typeStr {
    
    if ([typeStr isEqualToString:@"wantBuy"]) {
        
        [self.cellImageV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:kImage(@"CRPlaceholderImage")];
        self.nameLabel.text = model.jname;
        self.priceLabel.text = model.type;
        self.buyCountLabel.text = [NSString stringWithFormat:@"%@ %@ %@",model.bname,model.sname,model.cname];
        self.baojiazLabel.text = [model.count stringByAppendingString:@"人报价"];
        self.baojiazLabel.hidden = NO;
        self.addressLabel.hidden= YES;
        
        self.askBtn.hidden = YES;

//        [self.askBtn setTitle:@"报价" forState:UIControlStateNormal];
        
    } else if ([typeStr isEqualToString:@"offerBuy"]) {
        
        [self.cellImageV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:kImage(@"CRPlaceholderImage")];
        self.nameLabel.text = model.name;
        self.priceLabel.text = [NSString stringWithFormat:@"%@   ¥%@",model.type,model.price];
        self.buyCountLabel.text = [NSString stringWithFormat:@"%@ %@ %@",model.bname,model.sname,model.cname];
        
        self.askBtn.hidden = YES;
        self.baojiazLabel.hidden = YES;
        self.addressLabel.hidden= YES;
    } else {
        {
            [self.cellImageV sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:kImage(@"CRPlaceholderImage")];
            self.nameLabel.text = model.name;
            self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
            
            self.buyCountLabel.text = [NSString stringWithFormat:@"%d人付款",[model.amount intValue]];
            self.addressLabel.hidden= YES;
            
            self.askBtn.hidden = YES;
            self.baojiazLabel.hidden = YES;
            [self.askBtn setTitle:@"咨询" forState:UIControlStateNormal];
        }

    }
}

@end
