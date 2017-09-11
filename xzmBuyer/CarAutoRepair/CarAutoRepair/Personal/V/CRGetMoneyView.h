//
//  CRGetMoneyView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/20.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, tixianType) {
    
    wechatType  = 0,
    aliType
};

typedef void(^getMoneyBlock)(NSString *,NSString *);

@interface CRGetMoneyView : UIView

@property (nonatomic, assign) tixianType tixianType;

@property (nonatomic, copy) getMoneyBlock getMoneyBlock;

@end
