//
//  UIColor+ProjectColor.m
//  HengDuWS
//
//  Created by min－fo018 on 16/7/2.
//  Copyright © 2016年 北京银河盛泰科技有限公司. All rights reserved.
//

#import "UIColor+ProjectColor.h"

@implementation UIColor (ProjectColor)

+ (instancetype)mainTextColor {

    return [UIColor colorWithRed:100.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1.0];
    
}

+ (instancetype)mainSelectedColor {

    return [UIColor colorWithRed:216.0/255.0 green:46.0/255.0 blue:21.0/255.0 alpha:1.0];
    
}

+ (instancetype)mainGoodsTitleColor {

    return [UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1.0];
    
}

+ (instancetype)mainGoodsPriceColor {

    return [UIColor colorWithRed:248.0/255.0 green:9.0/255.0 blue:70.0/255.0 alpha:1.0];
    
}

+ (instancetype)mainBackgroundColor {

    return [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:234.0/255.0 alpha:1.0];
    
}

+ (instancetype)OSTextColor {

    return [UIColor colorWithRed:22.0/255.0 green:22.0/255.0 blue:22.0/255.0 alpha:1.0];
    
}

+ (instancetype)lineColor {

    return [UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1.0];
    
}

+ (instancetype)buttonGrayBackground {

    return [UIColor colorWithRed:153.0/255.0 green:153./255.0 blue:153.0/255.0 alpha:1.0];
    
}

+ (instancetype)KTBackgroundColor {
    
    return [UIColor colorWithRed:252.0/255.0 green:212.0/255.0 blue:214.0/255.0 alpha:1.0];
    
}
@end
