//
//  ISAddressProvinceModel.h
//  I Sports
//
//  Created by 连超 on 16/5/13.
//  Copyright © 2016年 superlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ISAddressCityModel;
@interface ISAddressProvinceModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, strong) NSArray <ISAddressCityModel *>*city;


@end

@class ISAddressCountryModel;
@interface ISAddressCityModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, strong) NSArray <ISAddressCountryModel *>*area;


@end

@interface ISAddressCountryModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *id;

@end