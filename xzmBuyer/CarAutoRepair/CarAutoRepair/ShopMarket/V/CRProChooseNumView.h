//
//  CRProChooseNumView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/20.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickMakeSureBlock)(NSString *);

@interface CRProChooseNumView : UIView

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, copy) clickMakeSureBlock clickMakeSureBlock;

@end
