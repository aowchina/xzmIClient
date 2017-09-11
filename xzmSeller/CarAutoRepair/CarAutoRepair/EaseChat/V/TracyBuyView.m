//
//  TracyBuyView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/18.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "TracyBuyView.h"
#import "CRWantBuyModel.h"

@interface TracyBuyView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end

@implementation TracyBuyView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}

- (void)reloadDataViewModel:(id<IMessageModel>)model {
    
    
    NSLog(@"%@",model.message.ext);
    
    if ([CRWantBuyModel isBuyInfo:model.message.ext]) {
        
        self.titleLabel.text = model.isSender ? @"请为我报价" : @"需要报价信息";
        
        NSLog(@"-----%@",model.message.ext);
        
        self.typeImageView.image = kImage(@"qixiu_gou");
        
        self.nameLabel.text = model.message.ext[@"carType"];
        
        self.detailLabel.text = model.message.ext[@"name"];

        self.bottomLabel.text = @"求购单";
    
    } else if ([CRWantBuyModel isOfferInfo:model.message.ext]) {
        
        self.titleLabel.text = model.isSender ? @"我的报价" : @"对方已报价";
        
        self.typeImageView.image = kImage(@"qixiu_fu");
        
        self.nameLabel.text = model.message.ext[@"carType"];
        
        self.detailLabel.text = model.message.ext[@"name"];
        
        /*
        self.typeImageView.image = kImage(@"qixiu_fu");
        
        self.nameLabel.text = @"去付款";
        
        self.detailLabel.text = [NSString stringWithFormat:@"¥%@元起",model.message.ext[@"price"]];
        
        self.detailLabel.textColor = [UIColor redColor];
         */
        
        self.bottomLabel.text = @"点击查看报价";
        
    } else if ([CRWantBuyModel isCollectionInfo:model.message.ext]) {
        
        self.titleLabel.text = model.isSender ? @"向对方收款" : @"对方向你收款";
        
        self.nameLabel.text = [NSString stringWithFormat:@"收款：¥%@",model.message.ext[@"price"]];
        
        self.detailLabel.text = @"点击查看详情";
        
        self.typeImageView.image = kImage(@"qixiu_kuan");
        
        self.bottomLabel.text = @"收款";
        
    } else if ([CRWantBuyModel isGoodsInfo:model.message.ext]) {
        
        self.titleLabel.text = model.message.ext[@"name"];
        
        self.nameLabel.text = model.message.ext[@"carType"];
        
        self.detailLabel.text = [NSString stringWithFormat:@"价格：¥%@",model.message.ext[@"price"]];
        
        self.detailLabel.textColor = [UIColor redColor];
        
        self.bottomLabel.text = @"点击查看";
    }

}

@end
