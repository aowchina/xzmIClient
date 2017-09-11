//
//  TracyCarCell.m
//  ChatDemo-UI3.0
//
//  Created by minfo019 on 17/5/11.
//  Copyright © 2017年 minfo019. All rights reserved.
//

#import "TracyCarCell.h"
#import "CRWantBuyModel.h"
#import "TracyBuyView.h"


@interface TracyCarCell ()

@property (nonatomic, strong) TracyBuyView *tracyBuyView;

@end

@implementation TracyCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    
    if (self) {
        self.hasRead.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.sendBubbleBackgroundImage = [[UIImage imageNamed:@"sele_bubbleView"] stretchableImageWithLeftCapWidth:5 topCapHeight:35];
    }
    
    return self;
}

- (BOOL)isCustomBubbleView:(id<IMessageModel>)model
{
    return YES;
}

- (void)setCustomModel:(id<IMessageModel>)model
{
    UIImage *image = model.image;
    if (!image) {
        [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
    } else {
        _bubbleView.imageView.image = image;
    }
    
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
}

- (void)setCustomBubbleView:(id<IMessageModel>)model
{
    _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
{
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
    if (model.isSender) {
        _bubbleView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 233 - 15, 8, 190, 127);
    }else {
        _bubbleView.frame = CGRectMake(63, 8, 190, 127);
    }
}

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model {
    
    if ([CRWantBuyModel isBuyInfo:model.message.ext]) {
    
        return model.isSender ? @"__buyInfoCellSendIdentifier__" : @"__buyInfoCellReceiveIdentifier__";
    
    } else if ([CRWantBuyModel isOfferInfo:model.message.ext]) {
        return model.isSender ? @"__offerInfoCellSendIdentifier__" : @"__offerInfoCellReceiveIdentifier__";
        
    } else if ([CRWantBuyModel isCollectionInfo:model.message.ext]) {
        
        return model.isSender ? @"__collectionInfoCellSendIdentifier__" : @"__collectionInfoCellReceiveIdentifier__";
        
    } else if ([CRWantBuyModel isGoodsInfo:model.message.ext]) {
        
        return model.isSender ? @"__goodsInfoCellSendIdentifier__" : @"__goodsInfoCellReceiveIdentifier__";
    }
    
    return nil;
}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
    NSLog(@"--%@ --- %@",model.text,model.message.ext);

    [self.tracyBuyView reloadDataViewModel:model];
    
    [self.bubbleView.backgroundImageView addSubview:self.tracyBuyView];
    
        if (model.isSender) {
            [self.tracyBuyView mas_makeConstraints:^(MASConstraintMaker *make) {

                make.left.equalTo(self.bubbleView.backgroundImageView.mas_left).offset(1);
                make.right.equalTo(self.bubbleView.backgroundImageView.mas_right).offset(-8);
                make.top.equalTo(self.bubbleView.backgroundImageView.mas_top).offset(1);
                make.bottom.equalTo(self.bubbleView.backgroundImageView.mas_bottom).offset(-2);
            }];
        } else {
            
            [self.tracyBuyView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.bubbleView.backgroundImageView.mas_left).offset(8);
                make.right.equalTo(self.bubbleView.backgroundImageView.mas_right).offset(-1);
                make.top.equalTo(self.bubbleView.backgroundImageView.mas_top).offset(1);
                make.bottom.equalTo(self.bubbleView.backgroundImageView.mas_bottom).offset(-2);
            }];
        }
    
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    if ([CRWantBuyModel iscustomInfo:model.message.ext]) {
        
        return 137;
    }
    return 0;
}

/** 懒加载 */
- (TracyBuyView *)tracyBuyView
{
    if (!_tracyBuyView) {
        _tracyBuyView = [TracyBuyView viewFromXib];
    }
    return _tracyBuyView;
}



@end
