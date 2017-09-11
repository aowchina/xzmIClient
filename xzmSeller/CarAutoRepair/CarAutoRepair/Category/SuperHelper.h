//
//  SuperHelper.h
//  SLNetWork
//
//  Created by superlian on 16/1/15.
//  Copyright © 2016年 superlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SuperHelper : NSObject

/**   实现计算字符串高度的方法
 **  string---需要计算的字符串  **
 **  size---字符串所占区域，例如：CGSizeMake(375, FLT_MAX) 表示宽375，高不确定 **
 **  font---字符串字体大小类型  **
 **/
+ (CGFloat)stringHeight:(NSString *)string containedSie:(CGSize)size labelFont:(UIFont *)font;
+ (CGFloat)stringWidth:(NSString *)string containedSie:(CGSize)size labelFont:(UIFont *)font;

+ (CGFloat)string:(NSString *)str andHeightWithWidth:(CGFloat)width andFont:(CGFloat)font;

//获取属性字符串
+ (NSMutableAttributedString *)getStringWithString:(NSString *)string  color:(UIColor *)color font:(UIFont *)font;
//拼接属性字符串
+ (NSMutableAttributedString *)matchingAttributedStringWithArray:(NSArray <NSMutableAttributedString *>*)array ;

//改变键盘高度
+ (void)keyboardChangeFrameWithView:(UIView *)view Offset:(CGFloat)offset;


//检测是否是手机号码
+ (BOOL)checkPhoneNum:(NSString *)phone;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//验证邮箱格式
+(BOOL)isValidateEmail:(NSString *)email;
#pragma 正则匹配用户密码 6 - 15 位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户名称
+ (BOOL)isTrueUsername:(NSString *)userName;
#pragma 正则匹配姓名(2 - 5位中文用户名)
+ (BOOL)isUsername:(NSString *)userName;

+ (BOOL)isProductname:(NSString *)productName;
/**
 * 尺寸
 */
+ (BOOL)isSize:(NSString *)size;
/** 价格 */
+ (BOOL)isPrice:(NSString *)price;

#pragma 中文需要转化格式传给服务器
+ (NSMutableString *)changeStringUTF:(NSString *)str;
#pragma 判断字符串是否为空和是否为空格的方法
+ (BOOL)isEmpty:(NSString *)str;

//有挡板的View
- (void)buildViewWithSuperView:(UIView *)superView subView:(UIView *)subView tag:(NSInteger)tag;
//移除有挡板的view
- (void)removeThisViewWithSuperView:(UIView *)superView Tag:(NSInteger)tag;



@end
