//
//  Header.h
//  OverseasesShopping
//
//  Created by minfo019 on 17/4/26.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#ifndef Header_h
#define Header_h


#define kWXAppID @"wx4d9f692ef2985664"
#define kWXPartner @"1481528832"
/** 支付宝回调地址 */
#define kAlipayNotifyUrl @"http://192.168.1.124/fzjh/api/front/zfb/notify_url.php"

/** 工程identifier */
#define kProjectIdentifier @"7000000008"
/** 当前屏高 */
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
/** 当前屏宽 */
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
/** 服务器繁忙的提示 */
#define kServerError @"出了点问题,请稍后重试"
/** 网络错误的提示 */
#define kNetError @"当前网络异常"
/** 提示当前无网络连接 */
#define kNotNet @"当前无网络连接"
//debugLog
#ifdef DEBUG

#define DDQLog(format, ...) NSLog(format, ## __VA_ARGS__)
#define DDQUserDefault  DDQLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);

#else

#define DebugLog(format, ...)

#endif

#define kImage(NSString) [UIImage imageNamed:(NSString)]


// RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//16进制取色
#define ColorForRGB(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >>8)/255.0) blue:((s &0xFF)/255.0) alpha:1.0]

#define kTextFieldColor  ColorForRGB(0x828282)

#define kUSER_DEFAULT [NSUserDefaults standardUserDefaults]
#define kHDUserId [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]
#define kUserImage [[NSUserDefaults standardUserDefaults] objectForKey:@"userPicture"]
#define kUserName [[NSUserDefaults standardUserDefaults] objectForKey:@"usernickname"]

#define KFont(font) [UIFont systemFontOfSize:(font)/1.0]

//#define EditImageURL @"http://192.168.1.110/zjxzm/"
//
//#define BaseURL @"http://192.168.1.110/zjxzm/api/users/"


#define EditImageURL @"http://zjxzm.min-fo.com/"

//#define BaseURL @"http://192.168.1.110/zjxzm/api/users/"


#define BaseURL @"http://zjxzm.min-fo.com/api/users/"


//  替代的宏： __weak typeof(self)weakSelf = self;  __strong __typeof(weakSelf)strongSelf = weakSelf;
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* Header_h */
