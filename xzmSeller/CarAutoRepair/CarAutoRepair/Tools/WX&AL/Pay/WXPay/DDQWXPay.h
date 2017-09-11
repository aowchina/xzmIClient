//
//  DDQWXPay.h
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"

@interface DDQWXPay : NSObject<WXApiDelegate>

/**
 *  唤起微信去支付
 *
 *  @param param  微信支付的所需参数:prepayId,nonceStr,timeStamp,partnerId
 *  @param result 唤起微信时的结果，为nil即为成功
 */
+ (void)WXPayParam:(NSDictionary *)param Result:(void(^)(NSError *WXError))result;

@end

FOUNDATION_EXPORT NSString *const kWXPID;//微信支付时所需的——商户PID
FOUNDATION_EXPORT NSString *const kWXNonceStr;//微信支付时所需的——描述nonce_str
FOUNDATION_EXPORT NSString *const kWXTimesTamp;//微信支付时所需的——时间戳timestamp
