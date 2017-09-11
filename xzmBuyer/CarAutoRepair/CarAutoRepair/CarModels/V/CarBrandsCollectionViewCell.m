//
//  CarBrandsCollectionViewCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CarBrandsCollectionViewCell.h"
#import "CRCarInfoModel.h"

@implementation CarBrandsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CRCarInfoModel *)model {
    
    [self.carImageV sd_setImageWithURL:[NSURL URLWithString:model.blogo] placeholderImage:kImage(@"CRPlaceholderImage")];
    
    self.carLabel.text = model.bname;
}

@end
