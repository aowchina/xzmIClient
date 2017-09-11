//
//  CRProHeadView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRProHeadView.h"
#import "CRProDetailModel.h"

@interface CRProHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;


@end

@implementation CRProHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)reloadDataWithModel:(CRProDetailModel *)model andImageArr:(NSArray *)array {
    
    self.nameLabel.text = model.name;
    self.typeLabel.text = [NSString stringWithFormat:@"%@",model.detail];
    self.priceLabel.text = [NSString stringWithFormat:@"¥：%@",model.price];
    self.buyCountLabel.text = [NSString stringWithFormat:@"已有%d人购买",[model.amount intValue]];
    
    for (NSInteger i = 0; i < array.count; i++) {
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, 209)];
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:[EditImageURL stringByAppendingString:array[i]]] placeholderImage:kImage(@"CRPlaceholderImage")];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.scroView addSubview:imageV];
    }

    self.proViewWidth.constant = kScreenWidth * array.count;
    
    [self.scroView layoutIfNeeded];
}

@end
