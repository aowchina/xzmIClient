//
//  SearchTextField.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/23.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "SearchTextField.h"

@implementation SearchTextField

//控制清除按钮的位置

//- (CGRect)clearButtonRectForBounds:(CGRect)bounds
//
//{
//    
//    return CGRectMake(bounds.origin.x + bounds.size.width - 50, bounds.origin.y + bounds.size.height -20, 16, 16);
//    
//}


//控制placeHolder的位置，左右缩20

-(CGRect)placeholderRectForBounds:(CGRect)bounds

{
    
    
    
    return CGRectInset(bounds, 25, 0);
    
//    CGRect inset = CGRectMake(bounds.origin.x+100, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    
//    return inset;
    
}

//控制显示文本的位置

- (CGRect)textRectForBounds:(CGRect)bounds

{
    
    return CGRectInset(bounds, 25, 0);
    
//    CGRect inset = CGRectMake(bounds.origin.x+190, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
//    
//    
//    
//    return inset;
    
    
}

//控制编辑文本的位置

- (CGRect)editingRectForBounds:(CGRect)bounds

{
    
    return CGRectInset(bounds, 25, 0);
    
    
//    
//    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width -10, bounds.size.height);
//    
//    return inset;
    
}

//控制左视图位置

- (CGRect)leftViewRectForBounds:(CGRect)bounds

{
    
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y + bounds.size.height / 2 - 6.5, 13, 13);
    
    return inset;
    
//    return CGRectInset(bounds, 10,0);
    
}

//控制placeHolder的颜色、字体

//- (void)drawPlaceholderInRect:(CGRect)rect
//
//{
//    UIColor *placeholderColor = ColorForRGB(0x828282);//设置颜色
//    [placeholderColor setFill];
//    
//    CGRect placeholderRect = CGRectMake(rect.origin.x, (rect.size.height- self.font.pointSize)/2, rect.size.width, self.font.pointSize);//设置距离
//    
////     CGRect placeholderRect = CGRectInset(rect, 25, 0);
//    
//    
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.lineBreakMode = NSLineBreakByTruncatingTail;
//    style.alignment = self.textAlignment;
//    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName, self.font, NSFontAttributeName, placeholderColor, NSForegroundColorAttributeName, nil];
//    
//    
//    [self.placeholder drawInRect:placeholderRect withAttributes:attr];
//}



@end
