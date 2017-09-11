//
//  CRSeeEvaluationCell.h
//  CarAutoRepair
//
//  Created by Min-Fo-027 on 2017/6/21.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CRSeeEvaluationModel;

@interface CRSeeEvaluationCell : UITableViewCell
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
/** 名字 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 评论内容 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/** model */
@property (nonatomic ,strong) CRSeeEvaluationModel *model;

- (void)setModel:(CRSeeEvaluationModel *)model;

- (CGFloat)height;

@end
