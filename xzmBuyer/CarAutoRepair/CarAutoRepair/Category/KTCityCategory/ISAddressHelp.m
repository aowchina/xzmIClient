//
//  ISAddressHelp.m
//  I Sports
//
//  Created by 连超 on 16/5/13.
//  Copyright © 2016年 superlian. All rights reserved.
//

#import "ISAddressHelp.h"
#import "ISAddressProvinceModel.h"

@interface ISAddressHelp () {
    id _target;
    SEL _selector;
}

@end

@implementation ISAddressHelp

static ISAddressHelp *addressHelp;

static NSString *loginType;

#pragma mark - 创建单例对象
+(ISAddressHelp *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        addressHelp = [[ISAddressHelp alloc] init];
        loginType = [[NSString alloc] init];
    });
    return addressHelp;
}

#pragma mark - 地址帮助
- (NSMutableArray *)getMyModelWith:(id)dataSource {
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in dataSource) {
        
        ISAddressProvinceModel *provinceModel = [ISAddressProvinceModel mj_objectWithKeyValues:dic];
        
        //把 市 放到 省
        NSMutableArray *cityAry = [NSMutableArray array];
        for (NSDictionary *cityDic in provinceModel.city) {
            
            ISAddressCityModel *cityModel = [ISAddressCityModel mj_objectWithKeyValues:cityDic];
            
            //把 县 放到市里面
            NSMutableArray *countryAry = [NSMutableArray array];
            for (NSDictionary *countryDic in cityModel.area) {
                ISAddressCountryModel *countryModel = [ISAddressCountryModel mj_objectWithKeyValues:countryDic];
                [countryAry addObject:countryModel];
            }
            cityModel.area = countryAry;
            
            [cityAry addObject:cityModel];
        }
        provinceModel.city = cityAry;
        
        [array addObject:provinceModel];
    }
    return array;
}

-(void)changeAddressTarget:(id)target selector:(SEL)selector {
    _target = target;
    _selector = selector;
}

- (void)addressChanged {
    if (!_target || !_selector) {
        return;
    }
    [_target performSelectorOnMainThread:_selector withObject:nil waitUntilDone:NO];
}

@end
