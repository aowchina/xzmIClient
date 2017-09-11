//
//  TracyPickView.h
//  ChildArt
//
//  Created by minfo019 on 16/10/25.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol tracy_pickViewDelegate;

@interface TracyPickView : UIView

@property (nonatomic, strong) UIPickerView *pickView;/** 选择 */

@property (nonatomic, strong) NSArray *dataArray;/** 数据源 */

- (id)initWithArray:(NSArray *)array;

+ (instancetype)pickViewWithArray:(NSArray *)array;

- (void)show;

@property (nonatomic, weak) id<tracy_pickViewDelegate> delegate;

@end

@protocol tracy_pickViewDelegate <NSObject>

- (void)chooseBank:(NSString *)bank andIndex:(NSInteger)index;

@end
