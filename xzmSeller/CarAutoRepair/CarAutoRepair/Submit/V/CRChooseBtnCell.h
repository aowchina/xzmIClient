//
//  CRChooseBtnCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/26.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickCameraBlock)();

@interface CRChooseBtnCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *canmraBtn;

@property (nonatomic, copy) clickCameraBlock clickCameraBlock;

@end
