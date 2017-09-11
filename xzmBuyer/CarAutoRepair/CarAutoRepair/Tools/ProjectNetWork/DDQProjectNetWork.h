//
//  DDQProjectNetWork.h
//  artistadmin
//
//  Created by Min-Fo_003 on 16/1/19.
//  Copyright © 2016年 Min_Fo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDQPOSTEncryption.h"

#define DDQDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

@interface DDQProjectNetWork : NSObject

/** 单利方法 */
+ (instancetype)sharedNetWork;

/**
 *  利用AFN异步POST请求
 *
 *  @param url     请求地址
 *  @param param   参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */
- (void)asyncAFNPOST:(NSString *)url Param:(NSArray *)param Success:(void(^)(id responseObjc,NSError *codeErr))success Failure:(void(^)(NSError *netErr))failure;//DDQDeprecated("Use - asyncAFNPOST:Param:Progress:Success:Failure");
/**
 *  利用AFN异步POST请求
 *
 *  @param url      请求地址
 *  @param param    参数
 *  @param progress 请求进度
 *  @param success  请求成功回调
 *  @param failure  请求失败回调
 *
 *  @return Session的任务
 */
- (NSURLSessionDataTask *)asyncAFNPOST:(NSString *)url Param:(NSArray *)param Progress:(void(^)(NSProgress *pro))progress Success:(void(^)(id responseObjc,NSError *codeErr))success Failure:(void(^)(NSError *netErr))failure;

/**
 *  利用afn实现传图
 *
 *  @param url     url地址
 *  @param param    请求参数
 *  @param imgArray 图片的data
 *  @param tagArray 图片修改时对应的tag(tip:上传图片时传nil就行)
 *  @param success 请求成功回调(tip:如果请求errorCode为0那么，responseObjc将是一条字符串)
 *  @param failure 网络失败回调
 */
- (void)asynAFNPOSTImage:(NSString *)url Param:(NSArray *)param ImageArray:(NSArray<NSData *> *)imgArray TagArray:(NSArray<NSString *> *)tagArray Success:(void(^)(id responseObjc,NSError *codeErr))success Failure:(void(^)(NSError *netErr))failure;

- (void)asyncPhotoListForPersonWithImageArray:(NSMutableArray *)imageArray parameterArray:(NSArray *)dataArray  url:(NSString *)url success:(EncryptionSuccess)success;

@end
