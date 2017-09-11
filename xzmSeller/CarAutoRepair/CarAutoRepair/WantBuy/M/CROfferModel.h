//
//  CROfferModel.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/14.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CROfferModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) BOOL btn_selected;


@end
