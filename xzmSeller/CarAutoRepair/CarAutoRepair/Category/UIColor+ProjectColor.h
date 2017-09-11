//
//  UIColor+ProjectColor.h
//  HengDuWS
//
//  Created by min－fo018 on 16/7/2.
//  Copyright © 2016年 北京银河盛泰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ProjectColor)

/** 首页上部的字体颜色 */
+ (instancetype)mainTextColor;

/** 首页上部被选中字颜色 */
+ (instancetype)mainSelectedColor;

/** 首页商品名称字体颜色 */
+ (instancetype)mainGoodsTitleColor;

/** 首页商品价格字体颜色 */
+ (instancetype)mainGoodsPriceColor;

/** 首页背景色 */
+ (instancetype)mainBackgroundColor;

/** 订单页文字颜色 */
+ (instancetype)OSTextColor;

/** 线的颜色 */
+ (instancetype)lineColor;

/** 按钮不可点击时的背景颜色 */
+ (instancetype)buttonGrayBackground;

+ (instancetype)KTBackgroundColor;

@end
