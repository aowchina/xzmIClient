//
//  CRAboutModel.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/9.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRAboutModel : NSObject

/** 版本号 */
@property (nonatomic ,strong) NSString *name;
/** 文件内容 */
@property (nonatomic ,strong) NSString *url;

@end
