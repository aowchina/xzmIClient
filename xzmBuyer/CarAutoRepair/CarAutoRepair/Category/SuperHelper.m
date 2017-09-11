//
//  SuperHelper.m
//  SLNetWork
//
//  Created by superlian on 16/1/15.
//  Copyright © 2016年 superlian. All rights reserved.
//

#import "SuperHelper.h"


@implementation SuperHelper

#pragma mark - 实现计算字符串高度的方法
/**
 * @ author SuperLian
 *
 * @ date   2015.10.20
 *
 * @ func   实现计算字符串高度的方法
 */
+ (CGFloat)stringHeight:(NSString *)string containedSie:(CGSize)size labelFont:(UIFont *)font {
    NSDictionary *dic = @{NSFontAttributeName : font};
    CGRect rect = [string boundingRectWithSize:size
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:dic
                                       context:nil];
    return rect.size.height;
}
+ (CGFloat)stringWidth:(NSString *)string containedSie:(CGSize)size labelFont:(UIFont *)font {
    NSDictionary *dic = @{NSFontAttributeName : font};
    CGRect rect = [string boundingRectWithSize:size
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:dic
                                       context:nil];
    return rect.size.width;
}

+ (CGFloat)string:(NSString *)str andHeightWithWidth:(CGFloat)width andFont:(CGFloat)font {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize  size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)  options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)  attributes:attribute context:nil].size;
    CGFloat height = size.height;
    return height;
}


#pragma mark - 判断以及输入
//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)checkPhoneNum:(NSString *)phone
{
    NSString *pattern = @"(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:phone];
    return isMatch;
}

//验证邮箱格式
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma 正则匹配用户密码 6 - 15 位数字 和 字母组合
//+ (BOOL)checkPassword:(NSString *) password {
//    NSString *pattern = @"^(?![ 0 - 9 ]+$)(?![a-zA-Z]+$)[a-zA-Z0- 9 ]{ 6 , 15 }";
//    NSPredicate *pred = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:password];
//    return isMatch;
//}
#pragma 正则匹配用户密码 6 - 15 位数字 或 字母组合x
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}
#pragma 正则匹配用户名称
+ (BOOL)isTrueUsername:(NSString *)userName {
    NSString * regex = @"^[a-zA-Z\u4e00-\u9fa5]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}
#pragma 正则匹配姓名
+ (BOOL)isUsername:(NSString *)userName
{
//    [\u4E00-\u9FA5]{2,5}(?:·[\u4E00-\u9FA5]{2,5})*
    
    NSString * regex = @"([\u4E00-\u9FA5]{2,7})|([a-zA-Z]{3,10})";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}

+ (BOOL)isProductname:(NSString *)productName
{
    //    [\u4E00-\u9FA5]{2,5}(?:·[\u4E00-\u9FA5]{2,5})*
    
    NSString * regex = @"^[(\u4e00-\u9fa5)|a-zA-Z0-9-_]{1,10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:productName];
    return isMatch;
}

+ (BOOL)isSize:(NSString *)size
{
    //    [\u4E00-\u9FA5]{2,5}(?:·[\u4E00-\u9FA5]{2,5})*
    
    NSString * regex = @"^([0-9][0-9]*)+(.[0-9]{1,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:size];
    return isMatch;
}

+ (BOOL)isPrice:(NSString *)price
{
    //    [\u4E00-\u9FA5]{2,5}(?:·[\u4E00-\u9FA5]{2,5})*
    
    NSString * regex = @"^([0-9][0-9]*)+(.[0-9]{1,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:price];
    return isMatch;
}

#pragma 中文需要转化格式传给服务器
+ (NSMutableString *)changeStringUTF:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    Byte *byteArray = (Byte *)[data bytes];
    NSMutableString *appendStr = [[NSMutableString alloc] init];
    for(int i=0;i<[data length];i++) {
        [appendStr appendFormat:@"%d#",byteArray[i]];
    }
    return appendStr;
}

#pragma 判断字符串是否为空和是否为空格的方法
+ (BOOL)isEmpty:(NSString *)str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}


//(使用)  [self setFontFamily:@"FagoOfficeSans-Regular" forView:self.view andSubViews:YES];

-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }
}

#pragma mark - Helper(设置tabBarItem的样式)
- (UITabBarItem *)tabBarItemWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageNamed:(NSString *)selectedName {
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                     selectedImage:[[UIImage imageNamed:selectedName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //设置文字样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    return tabBarItem;
}

//有挡板的View
- (void)buildViewWithSuperView:(UIView *)superView subView:(UIView *)subView tag:(NSInteger)tag{
    //fullView是window上放置的view，作为superView
    UIView *fullView = [[UIView alloc] init];
    fullView.frame = superView.window.bounds;
    fullView.tag = tag;//设置枚举表示view的类型（用来确定window上所加的那个view）
    fullView.backgroundColor = [UIColor clearColor];
    [superView.window addSubview:fullView];
    //blackView是暗黑色的背景view
    UIView *blackView = [[UIView alloc] init];
    blackView.frame = fullView.bounds;
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.5;
    [fullView addSubview:blackView];
    //subView是自定义的view也就是显示的view
    subView.center = fullView.center;
    subView.alpha = 1;
    [fullView addSubview:subView];
}

- (void)removeThisViewWithSuperView:(UIView *)superView Tag:(NSInteger)tag {
    [[superView.window viewWithTag:tag] removeFromSuperview];
}

//设置属性字符串
+ (NSMutableAttributedString *)getStringWithString:(NSString *)string  color:(UIColor *)color font:(UIFont *)font{
    NSMutableAttributedString *attrstring = [[NSMutableAttributedString alloc] initWithString:string];
    [attrstring addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attrstring.length)];
    [attrstring addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attrstring.length)];
    return attrstring;
}
+ (NSMutableAttributedString *)matchingAttributedStringWithArray:(NSArray <NSMutableAttributedString *>*)array {
    if (array.count > 0) {
        NSMutableAttributedString *beginString = [[NSMutableAttributedString alloc] initWithAttributedString:array[0]];
        for (int i = 0; i < array.count; i++) {
            if (i == 0) {
                continue;
            }else {
                [beginString insertAttributedString:array[i] atIndex:beginString.length];
            }
        }
        return beginString;
    }else {
        NSMutableAttributedString *alertString = [[NSMutableAttributedString alloc] initWithString:@"传入数组为空"];
        return alertString;
    }
}
//改变键盘高度
+ (void)keyboardChangeFrameWithView:(UIView *)view Offset:(CGFloat)offset {
    //设置动画的名字
    [UIView beginAnimations:@"Animation" context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.50];
    //??使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的位移
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - offset, view.frame.size.width, view.frame.size.height);
    //设置动画结束
    [UIView commitAnimations];
}
@end
