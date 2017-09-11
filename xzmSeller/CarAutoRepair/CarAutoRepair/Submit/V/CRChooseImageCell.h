//
//  CRChooseImageCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/26.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRChooseImageCell;

typedef void(^clickDeleteBtnBlock)(CRChooseImageCell *cell);

@interface CRChooseImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (nonatomic, strong) clickDeleteBtnBlock clickDeleteBtnBlock;

@end
