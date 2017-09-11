//
//  ISAddressHelp.h
//  I Sports
//
//  Created by 连超 on 16/5/13.
//  Copyright © 2016年 superlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ISAddressProvinceModel;
@interface ISAddressHelp : NSObject

@property (nonatomic, copy) NSString *p_id;
@property (nonatomic, copy) NSString *p_name;
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *country_id;
@property (nonatomic, copy) NSString *country_name;
@property (nonatomic, copy) NSString *loginType;
//单例对象
+(ISAddressHelp *)shareInstance;

-(NSMutableArray *)getMyModelWith:(id)dataSource;

-(void)changeAddressTarget:(id)target selector:(SEL)selector;

- (void)addressChanged;

@end
