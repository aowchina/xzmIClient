//
//  CRPersonalHeaderView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickOrderBtnBlock)(NSInteger btn_type);
typedef void(^clickSettingBtnBlock)();

@interface CRPersonalHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headViewImage;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (nonatomic, copy) clickOrderBtnBlock clickOrderBtnBlock;
@property (nonatomic, copy) clickSettingBtnBlock clickSettingBtnBlock;
@end
