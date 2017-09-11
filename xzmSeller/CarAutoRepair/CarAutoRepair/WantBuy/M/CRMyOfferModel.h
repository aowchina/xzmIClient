//
//  CRMyOfferModel.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/14.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CROfferModel;

@interface CRMyOfferModel : NSObject

@property (nonatomic, strong) NSString *cname;
@property (nonatomic, strong) NSString *img;
//@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *typelist;
@property (nonatomic, strong) NSString *iD;
@property (nonatomic, strong) NSString *vin;
@property (nonatomic, strong) NSString *pricelist;
@property (nonatomic, strong) NSString *jname;
@property (nonatomic, strong) NSArray <CROfferModel *> *tpdetail;
@property (nonatomic, strong) NSString *sname;
@property (nonatomic, strong) NSString *bname;

@end
