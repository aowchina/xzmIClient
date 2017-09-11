//
//  CRCertificationCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/19.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRCertificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *detailTextF;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageV;

@property (nonatomic,copy) void(^block)(NSString *str);

@end
