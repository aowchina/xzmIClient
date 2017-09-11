//
//  HDPickViewController.h
//  HengDuWS
//
//  Created by minfo019 on 16/7/7.
//  Copyright © 2016年 北京银河盛泰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ISAddressProvinceModel;
@class ISAddressCityModel;
@class ISAddressCountryModel;

typedef void(^chooseAdderssBlock)(ISAddressProvinceModel *Pmodel,ISAddressCityModel *Citymodel,ISAddressCountryModel *Comodel);
@interface HDPickViewController : UIViewController

@property (nonatomic, strong) chooseAdderssBlock block;

@end
