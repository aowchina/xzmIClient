//
//  CRAccessoriesSubmitView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRSubCarDetailModel;

typedef void(^changOldBlock)(UIButton *btn_Sender);

typedef void(^changUIBlock)(UIButton *btn_Sender);

typedef void(^brand_BtnBlock)(UIButton *btn_Sender);

typedef void(^other_BtnBlock)(UIButton *btn_Sender);

@interface CRAccessoriesSubmitView : UIView

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UITextField *vinTextF;

@property (weak, nonatomic) IBOutlet UITextView *assPeijianTextV;
@property (weak, nonatomic) IBOutlet UITextField *limitTextF;
@property (weak, nonatomic) IBOutlet UITextField *otherBrandTextF;

@property (nonatomic, strong) CRSubCarDetailModel *model;

@property (nonatomic, copy) changUIBlock changUIBlock;

@property (nonatomic, copy) brand_BtnBlock brand_BtnBlock;

@property (nonatomic, copy) other_BtnBlock other_BtnBlock;

@property (nonatomic, copy) changOldBlock changOldBlock;

@end
