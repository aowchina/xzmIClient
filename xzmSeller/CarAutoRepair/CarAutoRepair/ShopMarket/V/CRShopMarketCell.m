//
//  CRShopMarketCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/18.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRShopMarketCell.h"
#import "CRShopMarket.h"
#import "CRMyOfferModel.h"

@interface CRShopMarketCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;

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
        self.addressLabel.hidden= YES;
        
        [self.askBtn setTitle:@"报价" forState:UIControlStateNormal];
        
    } else {
        
        
        
        [self.askBtn setTitle:@"咨询" forState:UIControlStateNormal];
    }
    
}

- (void)setModel:(CRMyOfferModel *)model {
    
    [self.cellImageV sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:kImage(@"CRPlaceholderImage")];
    self.nameLabel.text = model.jname;
//    self.priceLabel.text = model.type;
    
    NSArray *array = @[@"原厂",@"拆车",@"品牌",@"其他"];
    self.priceLabel.text = [NSString stringWithFormat:@"%@   ¥%@",array[[model.typelist integerValue]],model.pricelist];
    
    if ([model.typelist integerValue] == 0) {

    }
    
    self.buyCountLabel.text = [NSString stringWithFormat:@"%@ %@ %@",model.bname,model.sname,model.cname];
 
    self.askBtn.hidden = YES;
    self.addressLabel.hidden= YES;
    
    
}

@end
