//
//  TRPersonalModel.h
//  CarAutoRepair
//
//  Created by minfo019 on 2017/8/29.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItemModel;

@interface TRPersonalModel : NSObject

@property (nonatomic, strong) NSString *headname;


@property (nonatomic, strong) NSArray <ItemModel *> *item;

@end

//@interface ItemModel : NSObject
//
//@property (nonatomic, strong) NSString *name;
//
//@property (nonatomic, strong) NSString *image;
//
//@end
