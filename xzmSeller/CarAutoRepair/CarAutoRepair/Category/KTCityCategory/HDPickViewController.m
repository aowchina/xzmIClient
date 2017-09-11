//
//  HDPickViewController.m
//  HengDuWS
//
//  Created by minfo019 on 16/7/7.
//  Copyright © 2016年 北京银河盛泰科技有限公司. All rights reserved.
//

#import "HDPickViewController.h"
#import "ISAddressHelp.h"
#import "ISAddressProvinceModel.h"

#define LineColor [UIColor colorWithRed:232.f/255 green:232.f/255 blue:234.f/255 alpha:0.7]

@interface HDPickViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, strong) NSArray <ISAddressProvinceModel *>*provinceArray;

@property (nonatomic, strong) NSArray <ISAddressCityModel *>*citys;

@property (nonatomic, strong) NSArray <ISAddressCountryModel *>*country;

@property (nonatomic, strong) ISAddressProvinceModel *pmodel;
@property (nonatomic, strong) ISAddressCityModel *citymodel;
@property (nonatomic, strong) ISAddressCountryModel *coumodel;

@property (nonatomic, strong) UIToolbar *toolbar;
@end

@implementation HDPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.provinceArray = [NSArray array];
    self.citys = [NSArray array];
    self.country = [NSArray array];
    [self initCity];
    [self buildPickView];
    [self buildTooBar];
    
    
}

- (void)buildTooBar {
    
    UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - 155, kScreenWidth, 35)];
    [self.view addSubview:toolbar];
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancel:)];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    
    toolbar.items=@[lefttem,centerSpace,right];
    _toolbar = toolbar;
    UILabel *linelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _toolbar.origin.y, _toolbar.frame.size.width, 1)];
    linelabel.backgroundColor = LineColor;
    [self.view addSubview:linelabel];
    UILabel *lineLabelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, linelabel.origin.y+35, _toolbar.frame.size.width, 1)];
    lineLabelBottom.backgroundColor = LineColor;
    [self.view addSubview:lineLabelBottom];
}

- (void)buildPickView {
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 120, kScreenWidth, 120)];
    self.picker.backgroundColor = [UIColor whiteColor];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    [self.view addSubview:self.picker];
    
    [self pickerView:self.picker didSelectRow:0 inComponent:1];
}

- (void)initCity {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"]];
    id dataSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    ISAddressHelp *help = [ISAddressHelp shareInstance];
    NSMutableArray *addressAry = [help getMyModelWith:dataSource];
    self.provinceArray = addressAry;
}


#pragma mark - 该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}

#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (0 == component) {
        return self.provinceArray.count;
    }
    if (1 == component) {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        self.citys = [NSArray array];
        if (rowProvince < self.provinceArray.count) {
            self.citys = self.provinceArray[rowProvince].city;
        }
        return self.citys.count;
    } else {
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        self.country = [NSArray array];
        if (rowCity < self.citys.count) {
            self.country = self.citys[rowCity].area;
        }
        return self.country.count;
    }
}

#pragma mark - 该方法返回的NSString将作为UIPickerView中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (0 == component) {
        return self.provinceArray[row].name;
    }
    if(1 == component){
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        self.citys = [NSArray array];
        if (rowProvince <= self.provinceArray.count) {
            self.citys = self.provinceArray[rowProvince].city;
        }
        if (row > self.citys.count-1) return nil;
        return self.citys[row].name;
    }else{
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        self.country = [NSArray array];
        if (rowCity <= self.citys.count) {
            self.country = self.citys[rowCity].area;
        }
        if (row > self.country.count-1) return nil;
        return self.country[row].name;
    }
}

#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if(0 == component) {
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    if(1 == component) {
        [pickerView reloadComponent:2];
    }
    NSInteger rowOne = [pickerView selectedRowInComponent:0];
    NSInteger rowTow = [pickerView selectedRowInComponent:1];
    NSInteger rowThree = [pickerView selectedRowInComponent:2];
    
    self.pmodel = [[ISAddressProvinceModel alloc] init];
    self.citymodel = [[ISAddressCityModel alloc] init];
    self.coumodel = [[ISAddressCountryModel alloc] init];
    
    self.pmodel = self.provinceArray[rowOne];
    self.citymodel = self.citys[rowTow];
    if (self.country.count != 0) {
        self.coumodel = self.country[rowThree];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneClick {

    [self dismissViewControllerAnimated:YES completion:nil];
    if (_block) {
        _block(self.pmodel,self.citymodel,self.coumodel);
    }
}

@end
