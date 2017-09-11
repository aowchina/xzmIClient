//
//  CRSeeEvaluationModel.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/21.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRSeeEvaluationModel : NSObject

/** 头像 */
@property (nonatomic ,strong) NSString *picture;
/** 名字 */
@property (nonatomic ,strong) NSString *name;
/** 时间 */
@property (nonatomic ,strong) NSString *addtime;
/** 评价内容 */
@property (nonatomic ,strong) NSString *content;

@end
