//
//  KTPayBottomView.h
//  KantoCooking
//
//  Created by minfo019 on 17/4/12.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancelPayBlock)();
typedef void(^aliPayActionBlock)();
typedef void(^balanceActionVlock)();
typedef void(^weChatPayActionBlock)();

@interface KTPayBottomView : UIView

@property (nonatomic, strong) cancelPayBlock cancelPayBlock;

@property (nonatomic, strong) aliPayActionBlock aliPayActionBlock;

@property (nonatomic, strong) balanceActionVlock balanceActionVlock;

@property (nonatomic, strong) weChatPayActionBlock weChatPayActionBlock;

@end
