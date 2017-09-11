//
//  DDQSigner.h
//  HengDuWS
//
//  Created by min－fo018 on 16/7/8.
//  Copyright © 2016年 北京银河盛泰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQSigner : NSObject

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict;

@end
