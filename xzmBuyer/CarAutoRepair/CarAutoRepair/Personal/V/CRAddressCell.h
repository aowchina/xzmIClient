//
//  CRAddressCell.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/1.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRAddressCell;
@class CRAddressListModel;
typedef void(^deleteBlock)(CRAddressCell *cell);
typedef void(^defaultBlock)(CRAddressCell *cell);

@interface CRAddressCell : UITableViewCell

@property (nonatomic,strong)UIButton *yesImgBtn;

- (void)reloadDataWithData:(CRAddressListModel *)data;



@property (nonatomic,copy)deleteBlock deleteblock;
-(void)deleteBlockWithData:(deleteBlock)deleteblock;

@end
