//
//  CROrderListFooterView.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/5/31.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnBlock)();
@interface CROrderListFooterView : UIView
/** 共计 */
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
/** 总价 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/** 按钮 */
@property (weak, nonatomic) IBOutlet UIButton *footerBtn;

/** block */
@property (nonatomic ,strong) btnBlock btnBlock;

- (void)reloadCellType:(NSInteger)type;

@end
