//
//  CRProDeatilCell.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRProDeatilCell.h"
#import "CRProDetailModel.h"

@interface CRProDeatilCell ()


@end

@implementation CRProDeatilCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)reloadDataWithModel:(CRProDetailModel *)model andIndex:(NSInteger)index {

    if (index == 2) {
        
        self.titleWidthMargin.constant = 62.5;
    } else {
        self.titleWidthMargin.constant = 35;
    }
    
    NSArray *array = @[@"已选",@"OEM",@"适用车型"];
    
    self.titleLabel.text = array[index];
    
    
    if (index == 0) {
        
        self.detailLabel.text = [model.chooseCount stringByAppendingString:@"件"];
        
    } else if (index == 1) {
        
        self.detailLabel.text = model.oem;
        
    } else if (index == 2) {
        
        self.detailLabel.text = [NSString stringWithFormat:@"适用%d款",model.carList.count];
        
    }
}

@end
