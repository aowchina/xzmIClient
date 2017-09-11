//
//  CRCarDetailModel.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/7.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRCarDetailModel : NSObject

@property (nonatomic, strong) NSString *cimage;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *carid;
@property (nonatomic, strong) NSString *cname;
@property (nonatomic, strong) NSString *sname;
@property (nonatomic, strong) NSString *bname;
@property (nonatomic, strong) NSString *issuedate;

@property (nonatomic, assign) BOOL cellSelected;

@property (nonatomic, strong) NSString *vin;
@property (nonatomic, strong) NSString *Series;
@property (nonatomic, strong) NSString *ProducedYear;
@property (nonatomic, strong) NSString *SalesName;
@property (nonatomic, strong) NSString *manufacturer;
@property (nonatomic, strong) NSString *Brand;

@property (nonatomic, strong) NSString *popType;

@property (nonatomic, strong) NSString *peijianName;




@end
