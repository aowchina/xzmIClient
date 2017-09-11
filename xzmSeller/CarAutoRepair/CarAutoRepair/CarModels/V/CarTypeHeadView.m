//
//  CarTypeHeadView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/24.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CarTypeHeadView.h"

@implementation CarTypeHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)reloadViewWithStr:(NSString *)str {
    self.timeLabel.text = str;
}

@end
