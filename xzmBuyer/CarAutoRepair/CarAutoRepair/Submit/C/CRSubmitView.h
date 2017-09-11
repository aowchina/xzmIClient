//
//  CRSubmitView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickPeijianBlock)(NSInteger type);

@interface CRSubmitView : UIView

@property (nonatomic, copy) clickPeijianBlock clickPeijianBlock;

@end
