//
//  CRAddressListModel.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/7.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRAddressListModel : NSObject

/** id */
@property (nonatomic ,strong) NSString *ID;
/** 详细地址 */
@property (nonatomic ,strong) NSString *user_address;
/** 市 */
@property (nonatomic ,strong) NSString *cname;
/** 区ID */
@property (nonatomic ,strong) NSString *user_qid;
/** 市ID */
@property (nonatomic ,strong) NSString *user_cid;
/** 电话 */
@property (nonatomic ,strong) NSString *user_tel;
/** 区ID */
@property (nonatomic ,strong) NSString *aname;
/** 省ID */
@property (nonatomic ,strong) NSString *user_pid;
/** 姓名 */
@property (nonatomic ,strong) NSString *user_name;
/** 是否默认 */
@property (nonatomic ,strong) NSString *isdefault;
/** 省 */
@property (nonatomic ,strong) NSString *pname;

@property(nonatomic, assign) BOOL is_Selected;
@end
