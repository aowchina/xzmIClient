//
//  CRAccessoriesWantHeadCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRAccessoriesWantHeadCell.h"
#import "CRCarDetailModel.h"
#import "CRSubCarDetailModel.h"
#import "CRShopMarket.h"

@interface CRAccessoriesWantHeadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageV;
@property (weak, nonatomic) IBOutlet UILabel *pingLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiLabel;


@property (weak, nonatomic) IBOutlet UIButton *reChooseBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWith;

@end

@implementation CRAccessoriesWantHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)reloadDataWithCarType:(CRCarDetailModel *)model andModel:(CRSubCarDetailModel *)subModel {
    
    if (model) {
        
        if ([model.popType isEqualToString:@"hand"]) {
            
            self.imageWith.constant = 120;
            
            [self.cellImageV sd_setImageWithURL:[NSURL URLWithString:model.cimage]];
            
            self.pingLabel.text = [NSString stringWithFormat:@"品牌：%@",model.bname];
            self.xiLabel.text = [NSString stringWithFormat:@"车系：%@",model.bname];
            self.chexingLabel.text = [NSString stringWithFormat:@"车型：%@款 %@",model.issuedate,model.bname];
            self.reChooseBtn.hidden = NO;
            
            self.chexingLabel.font = KFont(13);
            
        } else if ([model.popType isEqualToString:@"VIN"]) {
            self.imageWith.constant = 0;
            
            self.reChooseBtn.hidden = YES;
            
            self.pingLabel.text = [NSString stringWithFormat:@"品牌：%@",model.brand_name];
            self.xiLabel.text = [NSString stringWithFormat:@"车系：%@",model.model_name];
            self.chexingLabel.text = [NSString stringWithFormat:@"车型：%@款 %@",model.made_year,model.sale_name];
            
            self.chexingLabel.font = KFont(15);
        } else {
            
            self.reChooseBtn.hidden = YES;
        }
    } else {
        
        //        if ([subModel.wantType isEqualToString:@"wantBuy"]) {
        
        
        self.imageWith.constant = subModel.img ? 120 : 0;
        
        [self.cellImageV sd_setImageWithURL:[NSURL URLWithString:subModel.img] placeholderImage:nil];
        
        self.reChooseBtn.hidden = YES;
        
        self.pingLabel.text = [NSString stringWithFormat:@"品牌：%@",subModel.bname];
        self.xiLabel.text = [NSString stringWithFormat:@"车系：%@",subModel.sname];
        self.chexingLabel.text = subModel.cname;
        
        self.chexingLabel.font = KFont(15);
        
        //        }
    }
}

- (void)setSubCarDetailModel:(CRSubCarDetailModel *)subCarDetailModel {
    
    self.imageWith.constant = subCarDetailModel.img ? 120 : 0;
    
    [self.cellImageV sd_setImageWithURL:[NSURL URLWithString:subCarDetailModel.img] placeholderImage:nil];
    
    self.reChooseBtn.hidden = YES;
    
    self.pingLabel.text = [NSString stringWithFormat:@"品牌：%@",subCarDetailModel.bname];
    self.xiLabel.text = [NSString stringWithFormat:@"车系：%@",subCarDetailModel.sname];
    self.chexingLabel.text = subCarDetailModel.cname;
    
    self.chexingLabel.font = KFont(15);
}

- (void)setShopModel:(CRShopMarket *)shopModel {
    
    self.imageWith.constant = shopModel.img ? 120 : 0;
    
    [self.cellImageV sd_setImageWithURL:[NSURL URLWithString:shopModel.img] placeholderImage:nil];
    
    self.reChooseBtn.hidden = YES;
    
    self.pingLabel.text = [NSString stringWithFormat:@"品牌：%@",shopModel.bname];
    self.xiLabel.text = [NSString stringWithFormat:@"车系：%@",shopModel.sname];
    self.chexingLabel.text = shopModel.cname;
    
    self.chexingLabel.font = KFont(15);
    
}

- (void)setCarDetailModel:(CRCarDetailModel *)carDetailModel {

    if ([carDetailModel.popType isEqualToString:@"hand"]) {
        
        self.imageWith.constant = 120;
        
        [self.cellImageV sd_setImageWithURL:[NSURL URLWithString:carDetailModel.cimage]];
        
        self.pingLabel.text = [NSString stringWithFormat:@"品牌：%@",carDetailModel.bname];
        self.xiLabel.text = [NSString stringWithFormat:@"车系：%@",carDetailModel.bname];
        self.chexingLabel.text = [NSString stringWithFormat:@"车型：%@款 %@",carDetailModel.issuedate,carDetailModel.bname];
        self.reChooseBtn.hidden = NO;
        
        self.chexingLabel.font = KFont(13);
        
    } else if ([carDetailModel.popType isEqualToString:@"VIN"]) {
        self.imageWith.constant = 0;
        
        self.reChooseBtn.hidden = YES;
        
        self.pingLabel.text = [NSString stringWithFormat:@"品牌：%@",carDetailModel.brand_name];
        self.xiLabel.text = [NSString stringWithFormat:@"车系：%@",carDetailModel.model_name];
        self.chexingLabel.text = [NSString stringWithFormat:@"车型：%@款 %@",carDetailModel.made_year,carDetailModel.sale_name];
        
        self.chexingLabel.font = KFont(15);
    } else {
        
        self.reChooseBtn.hidden = YES;
    }
}

- (IBAction)chooseBtnAction:(UIButton *)sender {
    
    if (_chooseCarBlock) {
        _chooseCarBlock();
    }
    
}

@end
