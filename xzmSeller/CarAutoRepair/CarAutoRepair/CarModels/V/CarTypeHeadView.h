//
//  CarTypeHeadView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarTypeHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *headLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)reloadViewWithStr:(NSString *)str;

@end
