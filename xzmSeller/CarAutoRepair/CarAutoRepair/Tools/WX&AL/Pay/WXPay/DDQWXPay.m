//
//  DDQWXPay.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQWXPay.h"
#import "DDQSigner.h"

@implementation DDQWXPay

NSString *const kWXPID = @"WXPay_PID";
NSString *const kWXNonceStr = @"WXPay_NonceStr";
NSString *const kWXTimesTamp = @"WXPay_TimesTamp";

+ (void)WXPayParam:(NSDictionary *)param Result:(void (^)(NSError *))result {
    
    /** 微信请求类 */
    PayReq *pay_req = [[PayReq alloc] init];
    
    //微信appid
    pay_req.openID = kWXAppID;
    
    //微信支付分配的商户号
    pay_req.partnerId = kWXPartner;
    
    //微信返回的支付交易回话id
    pay_req.prepayId= param[kWXPID];

    //填写固定值sign = WXPay
    pay_req.package = @"Sign=WXPay";
    
    //好像是商品备注
    pay_req.nonceStr= param[kWXNonceStr];
    
    //时间戳
    pay_req.timeStamp = [param[kWXTimesTamp] floatValue];
    
    //参数字典，用以本地签名
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kWXAppID forKey:@"appid"];
    [params setObject:pay_req.partnerId forKey:@"partnerid"];
    [params setObject:pay_req.prepayId forKey:@"prepayid"];
    [params setObject:[NSString stringWithFormat:@"%.0u",(unsigned int)pay_req.timeStamp] forKey:@"timestamp"];
    [params setObject:pay_req.nonceStr forKey:@"noncestr"];
    [params setObject:pay_req.package forKey:@"package"];
    
    //md5签名
    DDQSigner *signer = [[DDQSigner alloc] init];
    NSString *sign = [signer createMd5Sign:params];
    pay_req.sign = sign;
    
    //注册微信
    [WXApi registerApp:kWXAppID];
    
    NSError *error = nil;
    if ([WXApi isWXAppInstalled]) {//是否安装微信
        
        if ([WXApi isWXAppSupportApi]) {//该版本微信是否支持OpenApi
            
            if ([WXApi sendReq:pay_req]) {//向微信发起请求
                
                result(error);
                
            } else {
            
                error = [NSError errorWithDomain:@"微信唤起失败" code:3 userInfo:nil];
                result(error);
                
            }
            
            
        } else {
        
            error = [NSError errorWithDomain:@"此设备微信版本过低" code:2 userInfo:nil];
            result(error);
            
        }
        
    } else {
    
        error = [NSError errorWithDomain:@"此设备尚未安装微信" code:1 userInfo:nil];
        result(error);
        
    }
    
}


@end
