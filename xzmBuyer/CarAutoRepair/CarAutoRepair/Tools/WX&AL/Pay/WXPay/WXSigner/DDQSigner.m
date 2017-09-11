//
//  DDQSigner.m
//  HengDuWS
//
//  Created by min－fo018 on 16/7/8.
//  Copyright © 2016年 北京银河盛泰科技有限公司. All rights reserved.
//

#import "DDQSigner.h"
#import "WXUtil.h"

@implementation DDQSigner

//创建package签名
- (NSString*)createMd5Sign:(NSMutableDictionary*)dict {
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", @"qazwsxedcrfvtgbyhnujmikolp123456"];
    
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    return md5Sign;
    
}
@end
