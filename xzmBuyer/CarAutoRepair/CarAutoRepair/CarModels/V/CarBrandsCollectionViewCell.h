//
//  CarBrandsCollectionViewCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRCarInfoModel;

@interface CarBrandsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carImageV;
@property (weak, nonatomic) IBOutlet UILabel *carLabel;

@property (nonatomic, strong) CRCarInfoModel *model;

@end
