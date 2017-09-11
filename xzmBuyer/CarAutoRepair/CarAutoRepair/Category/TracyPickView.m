//
//  TracyPickView.m
//  ChildArt
//
//  Created by minfo019 on 16/10/25.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import "TracyPickView.h"

@interface TracyPickView () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIToolbar   *_toolBar;/** tabbar */
    CGSize      _size;/** frame */
    UIView *_backView;/** 背景 */
}
@end

@implementation TracyPickView

- (id)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        self.alpha = 0;
        self.dataArray = array;
        _size = [[UIScreen mainScreen] bounds].size;
        self.backgroundColor = [UIColor clearColor];
        [self addsubViews];
    } return self;
}

- (void)addsubViews
{
    self.frame = (CGRect){CGPointZero, _size};
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    _backView = [[UIView alloc] initWithFrame:self.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.4;
    
    [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickbackView)]];
    
    [self addSubview:_backView];
    
    _toolBar = [[UIToolbar alloc] init];
    _toolBar.tintColor = [UIColor grayColor];
    _toolBar.frame = (CGRect){0, _size.height, _size.width, 44};
    [self addSubview:_toolBar];
    
    UIBarButtonItem *item1 = [UIBarButtonItem initWithTitle:@"取消" titleColor:kColor(0, 122, 255) target:self action:@selector(dismiss)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item3 = [UIBarButtonItem initWithTitle:@"确定" titleColor:kColor(0, 122, 255) target:self action:@selector(done)];
    
    _toolBar.items = [NSArray arrayWithObjects:item1, item2, item3, nil];
    
    self.pickView = [[UIPickerView alloc] init];
    self.pickView.showsSelectionIndicator = YES;
    self.pickView.backgroundColor = [UIColor whiteColor];
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    self.pickView.frame = (CGRect){0, _size.height + 44, _size.width, 206 - 44};
    [self addSubview:self.pickView];
    
}

+ (instancetype)pickViewWithArray:(NSArray *)array {
    TracyPickView *pickView = [[self alloc] initWithArray:array];
    [pickView show];
    
    return pickView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataArray[row];
}

- (void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        _toolBar.frame = (CGRect){0, _size.height - 206, _size.width, 44};
        self.pickView.frame = (CGRect){0, _size.height - 206 + 44, _size.width, 206 - 44};
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        _toolBar.frame = (CGRect){0, _size.height, _size.width, 44};
        self.pickView.frame = (CGRect){0, _size.height + 44, _size.width, 206 - 44};
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

- (void)done {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseBank:andIndex:)]) {
        [self.delegate chooseBank:[self.dataArray objectAtIndex:[self.pickView selectedRowInComponent:0]] andIndex:[self.pickView selectedRowInComponent:0]];
    }
    
    [self dismiss];
}

- (void)clickbackView {
    
    [self dismiss];
}

@end
