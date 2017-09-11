//
//  CRAccessoriesModel.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/12.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRAccessoriesModel : NSObject

/** 配件名称 */
@property (nonatomic ,strong) NSString *name;
/** 位置 */
@property (nonatomic ,strong) NSString *position;
/** oep号 */
@property (nonatomic ,strong) NSString *oem;
/** blame */
@property (nonatomic ,strong) NSString *bname;
/** sname */
@property (nonatomic ,strong) NSString *sname;
/** cname */
@property (nonatomic ,strong) NSString *cname;

@end
