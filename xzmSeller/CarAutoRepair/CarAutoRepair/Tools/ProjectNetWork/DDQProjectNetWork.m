 //
//  DDQProjectNetWork.m
//  artistadmin
//
//  Created by Min-Fo_003 on 16/1/19.
//  Copyright © 2016年 Min_Fo. All rights reserved.
//

#import "DDQProjectNetWork.h"

#import "DDQPOSTEncryption.h"
#import "SpellParameters.h"
#import "UICKeyChainStore.h"

@implementation DDQProjectNetWork

+(instancetype)sharedNetWork {

    static DDQProjectNetWork *net_work = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        net_work = [[self alloc] init];
        
    });
    
    return net_work;
    
}

/** 请求 */
- (void)asyncAFNPOST:(NSString *)url Param:(NSArray *)param Success:(void (^)(id, NSError *))success Failure:(void (^)(NSError *))failure {

    //获取设备八段
    NSString *spell = [SpellParameters getBasePostString:kProjectIdentifier];
    
    NSMutableString *paramString = [[NSMutableString alloc] initWithString:spell];
    
    if (param && param.count > 0) {
        
        for (int i = 0; i < param.count; i++) {
            
            id objc = param[i];
            NSAssert([objc isKindOfClass:[NSString class]], @"请求参数应为字符串");
            NSString *param = (NSString *)objc;
            [paramString appendFormat:@"*%@",param];
            
        }
        
    }
    
    //加密拼接字符串
    NSString *encryptionStr = [DDQPOSTEncryption stringWithPost:paramString projectId:kProjectIdentifier];
    
    //切割字符串
    NSArray *cutArray = [encryptionStr componentsSeparatedByString:@"&"];
    
    /** 参数字典 */
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    for (NSString *content in cutArray) {
        
        //根据“=”切割字符串
        NSArray *tempArray = [content componentsSeparatedByString:@"="];
        
        //创建参数字典值
        if (![[paramDic allKeys] containsObject:tempArray.firstObject]) {
            
            [paramDic setValue:tempArray.lastObject forKey:tempArray.firstObject];
            
        }
        
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.responseSerializer = responseSerializer;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = 100.0;
    manager.requestSerializer = requestSerializer;
    
    [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error = nil;
        
        id container = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
//        NSLog(@"%@----%@",container,str);

      
        if (container) {//服务器返回值为空
            
            NSInteger code = [[container valueForKey:@"errorcode"] integerValue];
            
            if (code == 0) {
                
                id decipherObjc = [DDQPOSTEncryption encrption_jsonDic:container];
                
                success(decipherObjc,error);
                
            } else {
            
                error = [NSError errorWithDomain:@"errorcode提示" code:code userInfo:nil];
                
                success(nil, error);
                
            }
                
        } else {
            
            error = [NSError errorWithDomain:@"没有收到服务器响应" code:107038 userInfo:nil];
            success(nil, error);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
    
}

- (NSURLSessionDataTask *)asyncAFNPOST:(NSString *)url Param:(NSArray *)param Progress:(void (^)(NSProgress *))progress Success:(void (^)(id, NSError *))success Failure:(void (^)(NSError *))failure {

    NSString *spell = [SpellParameters getBasePostString:kProjectIdentifier];
    
    NSMutableString *paramString = [[NSMutableString alloc] initWithString:spell];
    
    if (param && param.count > 0) {
        
        for (int i = 0; i < param.count; i++) {
            
            id objc = param[i];
            NSAssert([objc isKindOfClass:[NSString class]], @"请求参数应为字符串");
            NSString *param = (NSString *)objc;
            [paramString appendFormat:@"*%@",param];
            
        }
        
    }
    
    NSString *encryptionStr = [DDQPOSTEncryption stringWithPost:paramString projectId:kProjectIdentifier];
    
    NSArray *cutArray = [encryptionStr componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    for (NSString *str in cutArray) {
        
        if (![[paramDic allKeys] containsObject:[str substringToIndex:2]]) {
            
            [paramDic setValue:[str substringWithRange:NSMakeRange(3, str.length - 3)] forKey:[str substringToIndex:2]];
            
        }
        
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.responseSerializer = responseSerializer;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10.0;
    manager.requestSerializer = requestSerializer;
    
    NSURLSessionDataTask *dataTask = [manager POST:url parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error = nil;
        
        if (responseObject) {
            
            id container = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if (container) {
                
                NSInteger code = [[container valueForKey:@"errorcode"] integerValue];
                
                if (code == 0) {
                    
                    id decipherObjc = [DDQPOSTEncryption encrption_jsonDic:container];
                    
                    success(decipherObjc,error);
                    
                } else {
                    
                    error = [NSError errorWithDomain:@"errorcode提示" code:code userInfo:nil];
                    
                    success(nil, error);
                    
                }
                
            } else {
                
                success(container, error);
                
            }
            
        } else {
            
            error = [NSError errorWithDomain:@"没有收到服务器响应" code:107039 userInfo:nil];
            success(nil, error);
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);

    }];

    return dataTask;
    
}

/** 传图 */
- (void)asynAFNPOSTImage:(NSString *)url Param:(NSArray *)param ImageArray:(NSArray<NSData *> *)imgArray TagArray:(NSArray<NSString *> *)tagArray Success:(void (^)(id, NSError *))success Failure:(void (^)(NSError *))failure {
    
    //拼八段
    NSString *spell = [SpellParameters getBasePostString:kProjectIdentifier];
    
    //拼参数
    NSMutableString *mutable_string = [[NSMutableString alloc] initWithString:spell];
    
    if (param != nil && param.count != 0) {
        
        for (int i = 0; i<param.count; i++) {
            
            [mutable_string appendFormat:@"*%@",param[i]];
            
        }
        
    }
    
    //加密
    NSString *encrption_str = [DDQPOSTEncryption stringWithPost:mutable_string projectId:kProjectIdentifier];
    
    /** AFNSession */
    AFHTTPSessionManager *session_manager = [AFHTTPSessionManager manager];
    
    /** AFNRequest */
    AFHTTPRequestSerializer *requestSer = [AFHTTPRequestSerializer serializer];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    session_manager.responseSerializer = responseSerializer;
    
    //设置下
    requestSer.timeoutInterval = 40.0;
    [requestSer setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
    [requestSer setValue:@"UTF-8" forHTTPHeaderField:@"Charsert"];
    [requestSer setValue:[NSString stringWithFormat:@"%@;boundary=%@", @"multipart/form-data", [self uuid]] forHTTPHeaderField:@"Content-Type"];
    
    session_manager.requestSerializer = requestSer;
    
    //切割字符串
    NSArray *cutArray = [encrption_str componentsSeparatedByString:@"&"];
    
    //创建参数
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < cutArray.count; i++) {
        
        NSString *tmpStr = [cutArray objectAtIndex:i];
        
        NSArray *tmpArray = [tmpStr componentsSeparatedByString:@"="];
        
        NSString *paramKey = [tmpArray firstObject];
        
        NSString *paramValue = [[tmpArray lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [paramDic setValue:paramValue forKey:paramKey];
    }
    
    //请求
    [session_manager POST:url parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (imgArray > 0) {
            
            if (tagArray != nil && tagArray.count > 0) {
                
                for (int i = 0; i < imgArray.count; i ++) {
                    
                    NSData *data = [imgArray objectAtIndex:i];
                    NSString *name = [NSString stringWithFormat:@"img%d", [tagArray[i] intValue]];

                    [formData appendPartWithFileData:data name:name fileName:@"icon.png" mimeType:@"application/octet-stream;charset=UTF-8"];
                    
                }
                
            } else {
                
                for (int i = 0; i < imgArray.count; i ++) {
                    
                    NSData *data = [imgArray objectAtIndex:i];
                    NSString *name = [NSString stringWithFormat:@"img%d", i];
                    
                    [formData appendPartWithFileData:data name:name fileName:@"icon.png" mimeType:@"application/octet-stream;charset=UTF-8"];
                    
                }
                
            }
            
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error = nil;
        
        if (responseObject) {
            
            id container = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSInteger code = [[container valueForKey:@"errorcode"] integerValue];
            
            if (code == 0) {
                
                NSString *tipStr = @"上传成功!";
                success(tipStr, error);
                
            } else {
                
                error = [NSError errorWithDomain:@"errorcode提示" code:code userInfo:nil];
                success(nil, error);
                
            }
            
        } else {
            
            error = [NSError errorWithDomain:@"服务器无返回值" code:107038 userInfo:nil];
            success(nil, error);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
    
}

- (void)asyncPhotoListForPersonWithImageArray:(NSMutableArray *)imageArray parameterArray:(NSArray *)dataArray  url:(NSString *)url success:(EncryptionSuccess)success {
    
    DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
    post.encryptionSuccess = success;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //调用touxiang接口
        //八段
        NSString *spellString = [SpellParameters getBasePostString:kProjectIdentifier];
        //拼参数
        NSMutableString *temp_string = [[NSMutableString alloc] init];
        
        for (int i = 0; i<dataArray.count; i++) {
            [temp_string appendFormat:@"*%@",dataArray[i]];
        }
        
        NSString *post_string = [NSString stringWithFormat:@"%@%@",spellString,temp_string];
        //加密
        NSString *post_String = [DDQPOSTEncryption stringWithPost:post_string projectId:kProjectIdentifier];
        //拼接字符串
        NSString *BOUNDRY = [NSString stringWithFormat:@"%@",[self uuid]];
        NSString *PREFIX = @"--";
        NSString *LINEND = @"\r\n";
        NSString *MULTIPART_FROM_DATA = @"multipart/form-data";
        NSString *CHARSET = @"UTF-8";
        //图片
        int len=512;
        if (imageArray !=nil) {
            for (int i =0; i<imageArray.count; i++) {
                NSData *imageData = [imageArray objectAtIndex:i];
                //字节大小
                if(imageData !=nil){
                    len = (int)imageData.length + len;
                }
            }
        }
        
        //文本类型
        NSMutableData  * postData =[NSMutableData dataWithCapacity:len];
        
        //p0
        NSArray *postArray = [post_String componentsSeparatedByString:@"&"];
        
        NSMutableString *text = [[NSMutableString alloc]init];
        for (int i = 0; i<postArray.count; i++) {
            [text appendString:[NSString stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,LINEND]];
            
            NSString *key = [postArray objectAtIndex:i];
            
            NSArray * smallArray = [key componentsSeparatedByString:@"="];
            
            [text appendFormat:@"Content-Disposition: form-data; name=\"%@\"%@",[smallArray objectAtIndex:0],LINEND];
            
            [text appendFormat:@"Content-Type: text/plain; charset=UTF-8%@",LINEND];
            [text appendString:LINEND];
            
            NSString *str =[[smallArray objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [text appendFormat:@"%@",str];
            
            [text appendString:LINEND];
        }
        [postData appendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
        
        //文件数据
        
        if (imageArray.count != 0)
        {
            
            for (int i =0 ; i<imageArray.count; i++)
            {
                NSData *imagedata =  imageArray[i];
                [postData  appendData:[[NSString   stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,LINEND] dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSString *aaa = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"icon.png\"%@Content-Type: application/octet-stream;charset=UTF-8%@%@",[NSString stringWithFormat:@"img%d",i],LINEND,LINEND,LINEND];
                
                [postData  appendData: [aaa dataUsingEncoding:NSUTF8StringEncoding]];
                
                [postData  appendData:imagedata];
                [postData appendData:[LINEND dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
        }
        
        [postData appendData:[[NSString stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,PREFIX] dataUsingEncoding:NSUTF8StringEncoding]];
        //
        //        //网络请求
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        //
        [urlRequest setTimeoutInterval:5000];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
        [urlRequest setValue:CHARSET forHTTPHeaderField:@"Charsert"];
        [urlRequest setValue:[NSString stringWithFormat:@"%@;boundary=%@", MULTIPART_FROM_DATA,BOUNDRY] forHTTPHeaderField:@"Content-Type"];
        
        urlRequest.HTTPBody = postData;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
  
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
        
        NSString *str = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            success(dic);
        });
    });
}


//获取设备的UDID，唯一标识符给服务器
static NSString *uuidKey = @"ModelCenter uuid key";

- (NSString*)uuid {
    
    NSString *string = [UICKeyChainStore stringForKey:uuidKey];
    
    if (string) {
        
    }else{
        
        UIDevice *currentDevice = [UIDevice currentDevice];
        NSUUID* identifierForVendor = currentDevice.identifierForVendor;
        string = [identifierForVendor UUIDString];
        [UICKeyChainStore setString:string forKey:uuidKey];
        
    }
    
    return string;
    
}

@end
