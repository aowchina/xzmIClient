//
//  CREPCDetailModel.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/9.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CREPCDetailModel : NSObject

/** ID */
@property (nonatomic ,strong) NSString *ID;
/** 配件名称 */
@property (nonatomic ,strong) NSString *name;
/** 位置 */
@property (nonatomic ,strong) NSString *position;
/** oep号 */
@property (nonatomic ,strong) NSString *oem;

@end
