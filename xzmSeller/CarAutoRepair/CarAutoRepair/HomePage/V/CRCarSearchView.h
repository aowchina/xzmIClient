//
//  CRCarSearchView.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/25.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^searchBlock)();

@interface CRCarSearchView : UIView

@property (weak, nonatomic) IBOutlet UITextField *searchTexfF;


/** block */
@property (nonatomic ,strong) searchBlock searchBlock;

@end
