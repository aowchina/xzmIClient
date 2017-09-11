//
//  CarDepartmentCollectionViewCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CarDepartmentCollectionViewCell.h"
#import "CRSerialModel.h"

@interface CarDepartmentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *serialImageView;

@property (weak, nonatomic) IBOutlet UILabel *serialLabel;


@end

@implementation CarDepartmentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CRSerialModel *)model {
    
    [self.serialImageView sd_setImageWithURL:[NSURL URLWithString:model.simage] placeholderImage:kImage(@"CRPlaceholderImage")];
    
    self.serialLabel.text = model.sname;
    
}

@end
