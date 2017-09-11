//
//  CRMakeSureHeaderView.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CRMakeSureHeaderView : UIView
/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 电话 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/** 地址 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/** 背景 */
@property (weak, nonatomic) IBOutlet UIView *backView;


@end
