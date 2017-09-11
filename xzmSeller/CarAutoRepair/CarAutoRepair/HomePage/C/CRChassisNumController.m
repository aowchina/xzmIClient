//
//  CRChassisNumController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRChassisNumController.h"
#import "CRCarSearchView.h"
#import "CRChassisNumCell.h"
#import "CarTypeTableViewCell.h"
#import "CRChassisNumModel.h"

@interface CRChassisNumController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CRCarSearchView *carSearchView;
/** 左边数据 */
@property (nonatomic ,strong) NSArray *leftDataArr;
/** 右边数据 */
@property (nonatomic ,strong) NSArray *rightDataArr;

@property (nonatomic, strong) NSDictionary *infoDic;

@end

@implementation CRChassisNumController

static NSString * const idenyifier = @"chassisNumCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.leftDataArr = [NSMutableArray array];
    self.rightDataArr = [NSMutableArray array];
    
    self.infoDic = @{@"Manufacturers":@"厂家名称",@"Brand":@"品牌名称",@"Series":@"车系",@"Models":@"车型",@"SalesName":@"销售名称",@"SalesVersion":@"销售版本",@"Year":@"年款",@"EmissionStandard":@"排放标准",@"VehicleType":@"车辆类型",@"VehicleSize":@"车辆级别",@"ChassisCode":@"代号/底盘号",@"GuidingPrice":@" 	指导价格（万元）",@"ListingYear":@"上市年份",@"ListingMonth":@"上市月份",@"ProducedYear":@"生产年份",@"IdlingYear":@"停产年份",@"ProductionStatus":@"生产状态",@"SalesStatus":@"销售状态",@"Country":@"国别",@"VehicleAttributes":@"厂家类型(国产,合资,进口)",@"Generation":@"代数",@"Remark":@"备注",@"ModelCode":@"工信部车型代码",@"EngineModel":@"发动机型号",@"EngineManufacturer":@"发动机生产厂家",@"CylinderVolume":@"气缸容积",@"Displacement":@"排量（L）",@"Induction":@"进气形式",@"FuelType":@"燃油类型",@"FuelGrade":@"燃油标号",@"Horsepower":@"最大马力（PS）",@"PowerKw":@"最大功率（kW）",@"CylinderArrangement":@"气缸排列形式",@"Cylinders":@"气缸数（个）",@"ValvesPerCylinder":@"每缸气门数（个）",@"TransmissionType":@"变速器类型",@"TransmissionDescription":@"变速器描述",@"GearNumber":@"档位数",@"FrontBrake":@"前制动器类型",@"RearBrake":@"后制动器类型",@"PowerSteering":@"助力类型",@"EngineLocation":@"发动机位置",@"DriveMode":@"驱动方式",@"Wheelbase":@"轴距（mm）",@"Doors":@"车门数",@"Seats":@"座位数（个）",@"FrontTyre":@"前轮胎规格",@"RearTyre":@"后轮胎规格",@"FrontRim":@"前轮毂规格",@"RearRim":@"后轮毂规格",@"RimsMaterial":@"轮毂材料",@"SpareWheel":@"备胎规格",@"Sunroof":@"电动天窗",@"PanoramicSunroof":@"全景天窗",@"HidHeadlamp":@"氙气大灯",@"FrontFogLamp":@"前雾灯",@"RearWiper":@"后雨刷",@"AC":@"空调",@"AutoAC":@"自动空调",@"LevelId":@"LevelId"};

    [self setNav];
    [self buildSearchView];
    [self createTableView];
    
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 50, kScreenWidth, kScreenHeight - 64 -50)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.hidden = YES;
    
    self.tableView.backgroundColor = kColor(234, 234, 236);
    /** 去tableview的线 */
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.tableHeaderView = [CarTypeTableViewCell viewFromXib];
//    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CRChassisNumCell" bundle:nil] forCellReuseIdentifier:idenyifier];
}


- (void)buildSearchView {
    
    self.carSearchView = [CRCarSearchView viewFromXib];
    self.carSearchView.frame = CGRectMake(0, 64, kScreenWidth, 50);
    [self.view addSubview:self.carSearchView];
    
    __weak typeof(self)wself = self;
    self.carSearchView.searchBlock = ^{
        
        [wself.view endEditing:YES];
        
        wself.tableView.hidden = YES;
        
        [wself requestData];
    };
}

- (void)setNav {
    /** 设置标题 */
    self.controllerName = @"车架号查询";
    /** 左按钮 */
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qixiu_jiantouBackIcon" target:self action:@selector(leftBarButtonItemAction) width:11 height:21];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rightDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CRChassisNumCell *cell = [tableView dequeueReusableCellWithIdentifier:idenyifier forIndexPath:indexPath];

    if (self.rightDataArr.count == 0)
    {
        self.leftDataArr = nil;
    }
    else
    {
        if ([self.infoDic objectForKey:self.leftDataArr[indexPath.row]]) {
            
            cell.typeLabel.text = [self.infoDic objectForKey:self.leftDataArr[indexPath.row]];
            cell.valueLabel.text = [NSString stringWithFormat:@"%@",self.rightDataArr[indexPath.row]];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)leftBarButtonItemAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据

- (void)requestData
{
    if (self.carSearchView.searchTexfF.text.length != 17)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"请输入正确的车架号!"];
        return;
    }
    
    NSString *ChassisNumber_Url = [self.baseUrl stringByAppendingString:@"cha/Vin.php"];
    NSArray *arr = @[kHDUserId,self.carSearchView.searchTexfF.text];
    [self showHud];
    
    [self.netWork asyncAFNPOST:ChassisNumber_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSInteger code = codeErr.code;
        
        NSLog(@"%@",responseObjc);
        
        if (!code)
        {
            
//            NSInteger iType = [responseObjc[@"biaoshi"] integerValue];
//            
            
//                if (iType == 1) {// 标识为1有数据
            
                //                NSDictionary *dic = responseObjc[@"che"][@"Result"];
                //
                //                NSDictionary *dic1 = arr[0];
                //
                
                //
                NSArray *array = responseObjc[@"che"][@"Result"];
                
                if (array.count > 0) {
                    
                    NSDictionary *dic = array[0];
                    
//                    self.vinModel = [CRCarVINModel mj_objectWithKeyValues:dic];
                    
                    self.leftDataArr = [NSMutableArray arrayWithArray:dic.allKeys];
                    
                    self.rightDataArr = [NSMutableArray arrayWithArray:dic.allValues];
                    
                    self.tableView.hidden = NO;
                    
                    [self.tableView reloadData];
                    
//                    self.vinModel.vin = self.carSearchView.searchTexfF.text;
//                    
//                    self.bottomHeight = 43;
//                    
//                    self.bottomBtn.hidden = NO;
//                    
//                    self.tableView.hidden = NO;
//                    
//                    self.tableView.frame = CGRectMake(0, 64 + 50, kScreenWidth, kScreenHeight - 64 -50 - self.bottomHeight);
//                    
//                    [self.tableView reloadData];
                    
                } else {
                    
                    [MBProgressHUD alertHUDInView:self.view Text:@"暂无车架号信息"];
                }
                
//            } else {
//                
//                [MBProgressHUD alertHUDInView:self.view Text:@"暂无该类车型"];
//            }
        }
        else if (code == 12)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"用户未登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else if (code == 13)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请输入车架号"];
        }
        else if (code == 14)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"车架号查询失败"];
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}


/*
- (void)requestData
{
    if (self.carSearchView.searchTexfF.text.length != 17)
    {
        [MBProgressHUD alertHUDInView:self.view Text:@"请输入正确的车架号!"];
        return;
    }
    
    NSString *ChassisNumber_Url = [self.baseUrl stringByAppendingString:@"cha/Vin.php"];
    NSArray *arr = @[kHDUserId,self.carSearchView.searchTexfF.text];
    [self showHud];
    [self.netWork asyncAFNPOST:ChassisNumber_Url Param:arr Success:^(id responseObjc, NSError *codeErr) {
        [self endHud];
        NSInteger code = codeErr.code;
        
        NSLog(@"%@",responseObjc);
        if (!code)
        {
            NSInteger iType = [responseObjc[@"biaoshi"] integerValue];
            
            if (iType == 1) {// 标识为1有数据
                
                NSArray *arr = [responseObjc[@"che"][@"showapi_res_body"] allValues];
                
                if (arr.count > 2) {
                    
                    NSString *brand_str = arr[19];
                    NSString *model_str = arr[2];
                    NSString *sale_str = arr[4];
                    NSString *carType_str = arr[12];
                    NSString *vin_str = arr[10];
                    NSString *engine_str = arr[24];
                    NSString *power_str = arr[15];
                    NSString *jet_str = arr[11];
                    NSString *fuel_str = arr[8];
                    NSString *transmission_str = arr[1];
                    NSString *cylinderNumer_str = arr[22];
                    NSString *cylinderForm_str = arr[5];
                    NSString *output_str = arr[18];
                    NSString *made_str = arr[13];
                    NSString *air_str = arr[16];
                    NSString *seat_str = arr[17];
                    NSString *vehicle_str = arr[20];
                    NSString *door_str = arr[9];
                    NSString *carBody_str = arr[12];
                    NSString *manufacturer_str = arr[14];
                    NSString *gears_str = arr[3];
                    NSString *carWeight_str = arr[0];
                    NSString *assembly_str = arr[6];
                    
                    self.rightDataArr = @[brand_str,model_str,sale_str,carType_str,vin_str,engine_str,power_str,jet_str,fuel_str,transmission_str,cylinderNumer_str,cylinderForm_str,output_str,made_str,air_str,seat_str,vehicle_str,door_str,carBody_str,manufacturer_str,gears_str,carWeight_str,assembly_str];
                    
                    self.tableView.hidden = NO;
                    
                    [self.tableView reloadData];
                    
                }
                
            } else {
                
                [MBProgressHUD alertHUDInView:self.view Text:@"暂无该类车型"];
            }
        }
        else if (code == 12)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"用户未登录"];
            [UIApplication sharedApplication].keyWindow.rootViewController = self.loginNav;
        }
        else if (code == 13)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"请输入车架号"];
        }
        else if (code == 14)
        {
            [MBProgressHUD alertHUDInView:self.view Text:@"车架号查询失败"];
        }
        else
        {
            [MBProgressHUD alertHUDInView:self.view Text:kServerError];
        }
        
    } Failure:^(NSError *netErr) {
        [self endHud];
        [MBProgressHUD alertHUDInView:self.view Text:kNetError];
    }];
}
*/

@end
