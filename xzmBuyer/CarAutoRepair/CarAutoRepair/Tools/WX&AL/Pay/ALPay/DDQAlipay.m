//
//  DDQAlipay.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQAlipay.h"
#import "Order.h"
#import "DataSigner.h"

#import <AlipaySDK/AlipaySDK.h>

#define kAlipayPartner @"2088021102567879"

#define kAlipaySeller @"yanxiaoyi@min-fo.com"

#define kAlipayPrivateKey1 @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANGWwbLA4yzaBAUk4W0l9qhZfqKWOpJiDOQGl83TQKpIElifvvH9eMBngI3qCsTMn726sa+BfMa1IyjmSOTYbT84yBqyvXbDItmoMTkN1fV17gA66Y3DZcxdIw0/aNYAhrazYHjhoaa9OeoZX1VP16dRlvptoHEqYKNZgJgtvMb/AgMBAAECgYA/+stqa+Ntf6gWgemmzh37ykYUD9QVd4UD3tdcZ46n7JRdJXa+nGfOJEpkB/v9k5F385PmRZr3dbgj9hhuc3r1ckpIVGFUbwUgftLkq9eqJd1+XGTcrrI/i4mr+D//IK0FNKqHtZEdUKOvApAoFHICBqus6YDmPczr7TO2tAAlAQJBAOsJa2OTKIhUCdFZJSQdKZP2TT76xjSZI6omKspGiNrsBYQNcZXJFB/qSlT5h3QOkJXIzRHcMn3knhI/DOeF5T8CQQDkSElq7/HWQuEWzp12WO19zcaqggYi/iA30m7owrJHdgUUm/zGznphuCXKf9LDukPLAtNwAzSHvp2GhlzuI+5BAkEA6LWS1ixF3XUXo2eYFoGpQQ6EvO6egEV/wl+3zj64EcnOTEjjRWKpwk+++RN2wboJ/cOrBxv2Ah/xQi+bH0C7EQJAW+mq/c58TauB21/3UFY/0P5QNgjCFcbCDBfDJh52D4W6R/ECVr190uiE9sJ+huXxM8UAgsIXnWwnGqnwssVuwQJAFe7tTyGCnqm63FTXgvz3N+1XSfWC+8W9Oc4kIDeXnEm0HpZXZQZVk/myQxkrwTz0z0pzbFnEAlQ6KSb9CWbaqQ=="


#define orderSpec @"alipay_sdk=alipay-sdk-php-20161101&app_id=2017051507246370&biz_content=%7B%22subject%22%3A%22App%5Cu652f%5Cu4ed8%22%2C%22out_trade_no%22%3A%22aborad149561315646131794165%22%2C%22timeout_express%22%3A%2260m%22%2C%22total_amount%22%3A0.01%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&charset=UTF-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2F192.168.1.102%2Fsellaborad%2Fapi%2Forder%2FZfbNotify.php&sign_type=RSA&timestamp=2017-05-26+14%3A24%3A22&version=1.0&sign=YJrv8EH6P6edjZ1iYOuBaI%2BcHbj6TzP2wn%2BcIj%2B4WuUvVf6qo%2FhBSDEMJoqC8wZ9iUYiHfJvckrvIYr2F20CiFkB25t9KAmdJOH3bhSvUS51AnsObQwyzajYZoYEdRwgYc4ctg12gcCS4I2riSZoD1lfveHJX%2BAL%2BcCTLpysNwI%3D"


//#define kAlipayNotifyUrl @"http://61.50.136.140/hondo_wx/api/zfb/notify_url.php"

@implementation DDQAlipay

NSString *const kALOrderId = @"ALPay_OrderId";
NSString *const kALGoodsName = @"ALPay_GoodsName";
NSString *const kALGoodsPrice = @"ALPay_GoodsPrice";
NSString *const kAlipayPrivateKey = @"ALPay_PrivateKey";
+ (void)alipay_creatSignWithParam:(NSDictionary *)param_c PaySuccess:(void (^)())success PayFailure:(void (^)(NSDictionary *))failure {
    
    NSString *partner = kAlipayPartner;
    NSString *seller = kAlipaySeller;
    NSString *privateKey = kAlipayPrivateKey1;
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = param_c[kALOrderId]; //订单ID（由商家自行制定）
    order.productName = param_c[kALGoodsName]; //商品标题
    order.productDescription = @"无"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[param_c[kALGoodsPrice] floatValue]]; //商品价格

    order.notifyURL = kAlipayNotifyUrl; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //定义URL types
    NSString *appScheme = @"OverseasesShopping";
    
    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    
    if (signedString != nil) {
        
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //如果是唤起的网页版，则AL结果回调走这
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            if ([[resultDic valueForKey:@"resultStatus"] intValue] == 9000) {

                success();
                
            } else {
                
                failure(resultDic);
                
            }
            
        }];
    }

}

@end
