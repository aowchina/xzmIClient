//
//  CROrderDetailBottomView.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/15.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancelBlock)();
typedef void(^payBlock)();

@interface CROrderDetailBottomView : UIView
/** 合计总价 */
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
/** 取消订单按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/** 立即支付按钮 */
@property (weak, nonatomic) IBOutlet UIButton *payBtn;


@property (nonatomic ,strong) cancelBlock cancelBlock;
@property (nonatomic ,strong) payBlock payBlock;


@end
