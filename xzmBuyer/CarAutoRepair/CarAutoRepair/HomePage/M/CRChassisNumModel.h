//
//  CRChassisNumModel.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/9.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRChassisNumModel : NSObject

/** 品牌名称 */
@property (nonatomic ,strong) NSString *value;

/** 品牌名称 */
@property (nonatomic ,strong) NSString *brand_name;
/** 车型名称 */
@property (nonatomic ,strong) NSString *model_name;
/** 销售名称  */
@property (nonatomic ,strong) NSString *sale_name;
/** 车辆类型 */
@property (nonatomic ,strong) NSString *car_type;
/** 17位的车架号vin */
@property (nonatomic ,strong) NSString *vin;
/** 发动机型号 */
@property (nonatomic ,strong) NSString *engine_type;
/** 功率/转速 */
@property (nonatomic ,strong) NSString *power;
/** 发动机喷射类型 */
@property (nonatomic ,strong) NSString *jet_type;
/** 燃油类型 */
@property (nonatomic ,strong) NSString *fuel_Type;
/** 变速器类型 */
@property (nonatomic ,strong) NSString *transmission_type;
/** 发动机缸数 */
@property (nonatomic ,strong) NSString *cylinder_number;
/** 气缸形式 */
@property (nonatomic ,strong) NSString *cylinder_form;
/** 排量（L）  */
@property (nonatomic ,strong) NSString *output_volume;
/** 生产年份 */
@property (nonatomic ,strong) NSString *made_year;
/** 安全气囊 */
@property (nonatomic ,strong) NSString *air_bag;
/** 座位数 */
@property (nonatomic ,strong) NSString *seat_num;
/** 车辆级别 */
@property (nonatomic ,strong) NSString *vehicle_level;
/** 车门数 */
@property (nonatomic ,strong) NSString *door_num;
/** 车身形式 */
@property (nonatomic ,strong) NSString *car_body;
/** 厂家名称*/
@property (nonatomic ,strong) NSString *manufacturer;
/** 档位数 */
@property (nonatomic ,strong) NSString *gears_num;
/** 装备质量（KG） */
@property (nonatomic ,strong) NSString *car_weight;
/** 组装厂 */
@property (nonatomic ,strong) NSString *assembly_factory;
/** 0为成功，其他为失败 */
@property (nonatomic ,strong) NSString *ret_code;

@end
