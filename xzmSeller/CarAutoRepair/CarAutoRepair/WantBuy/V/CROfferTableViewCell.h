//
//  CROfferTableViewCell.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/2.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CROfferTableViewCell;
@class CROfferModel;
typedef void(^priceBlock)(UIButton *,CROfferTableViewCell *);

typedef void(^textChangeBlock)(NSString *);

@interface CROfferTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *midTextF;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *midMoneyLabel;

@property (nonatomic, copy) priceBlock priceBlock;

//@property (nonatomic, strong) CROfferModel *model;

- (void)reloadDataWithModel:(CROfferModel *)model andPushType:(NSInteger)type;

@property (nonatomic, strong) textChangeBlock textChangeBlock;

@end
