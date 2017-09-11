//
//  TracyCarViewController.m
//  ChatDemo-UI3.0
//
//  Created by minfo019 on 17/5/11.
//  Copyright © 2017年 minfo019. All rights reserved.
//

#import "TracyCarViewController.h"
#import "TracyCarCell.h"
#import "CRWantBuyModel.h"
#import "CRAccessoriesOfferController.h"
#import "CRWantAccessoriesController.h"
#import "CRAccessoriesSubmmitController.h"
#import "CROrderReceiptViewController.h"
#import "CRProDeatilController.h"

@interface TracyCarViewController ()

@end

@implementation TracyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.chatType == 1000) {
        
        [self sendTextMessage:@"您好，请问这件商品还有吗？"];
        
        NSString *message = @"[商品信息]";
        
        [self sendTextMessage:message withExt:@{@"extType":@"shopInfo",@"infoId":@"10086",@"name":@"奔驰",@"icon":@"www",@"price":@"60",@"carType":@"奔驰A"}];
    }
    
    /** 设置用户头像大小 */
    [[TracyCarCell appearance] setAvatarSize:40.f];
    /** 设置头像圆角 */
    [[TracyCarCell appearance] setAvatarCornerRadius:20.f];
    
    if ([self.chatToolbar isKindOfClass:[EaseChatToolbar class]]) {
        /** 自定义按钮 */
        /*
        [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"chat_qixiu_icon_qg"] highlightedImage:[UIImage imageNamed:@"chat_qixiu_icon_qg"] title:@"求购"];
        [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"chat_qixiu_icon_baojia"] highlightedImage:[UIImage imageNamed:@"chat_qixiu_icon_baojia"] title:@"报价"];
         
        [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"chat_qixiu_icon_shoukuan"] highlightedImage:[UIImage imageNamed:@"chat_qixiu_icon_shoukuan"] title:@"收款"];
         */
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOfferNoti:) name:@"sendOfferMessage" object:nil];
}

- (void)receiveOfferNoti:(NSNotification *)noti {
    
    NSDictionary *dic = noti.object;
    
    NSString *message = @"[报价信息]";
    
    [self sendTextMessage:message withExt:dic];
    
}

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message {
    
    [super messageViewController:viewController modelForMessage:message];
    
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    
#pragma a 消息显示用户昵称和头像
    
    if (model.isSender == YES) {//本人发的
        
        model.avatarImage = kImage(@"EaseUIResource.bundle/user");
        // model.avatarURLPath = kUserImage;//头像网络地址
        
        model.avatarURLPath = kUserImage;
        
        return model;
        
    } else {
        model.avatarImage = kImage(@"EaseUIResource.bundle/user");
        if (self.headUrl) {
            model.avatarURLPath = self.headUrl;
        } else {
            model.avatarURLPath = message.ext[@"userHeadImage"];//头像网络地址
        }
        return model;
    }
    
    
}


/** 自定义红包Cell*/
- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel
{
    NSDictionary *ext = messageModel.message.ext;
    
    if ([CRWantBuyModel iscustomInfo:ext]) {
        /** 红包的卡片样式*/
        TracyCarCell *cell = [tableView dequeueReusableCellWithIdentifier:[TracyCarCell cellIdentifierWithModel:messageModel]];
        if (!cell) {
            cell = [[TracyCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TracyCarCell cellIdentifierWithModel:messageModel] model:messageModel];
            
            cell.delegate = self;
        }
        
        cell.model = messageModel;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    NSDictionary *ext = messageModel.message.ext;
    if ([CRWantBuyModel iscustomInfo:ext]) {
        return [TracyCarCell cellHeightWithModel:messageModel];
    }
    return 0;
}

/** 未读消息回执 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController shouldSendHasReadAckForMessage:(EMMessage *)message read:(BOOL)read
{
    NSDictionary *ext = message.ext;
    if ([CRWantBuyModel iscustomInfo:ext]) {
        return YES;
    }
    return [super shouldSendHasReadAckForMessage:message read:read];
}

#pragma a 发布消息
- (void)messageViewController:(EaseMessageViewController *)viewController didSelectMoreView:(EaseChatBarMoreView *)moreView AtIndex:(NSInteger)index {
    
    /*
    __weak typeof(self) weakSelf = self;

    if (index == 3) {
        
        CRWantAccessoriesController *accBuyC = [[CRWantAccessoriesController alloc] init];
        
        accBuyC.popType = 1;
        
//        accBuyC.buyInfoBlock = ^(NSDictionary *dic) {
//            
//            NSString *message = @"[求购信息]";
//            
//            [weakSelf sendTextMessage:message withExt:dic];
//            
//        };
        
        NSString *message = @"[求购信息]";
        
        [weakSelf sendTextMessage:message withExt:@{@"extType":@"purchaseInfo",@"infoId":@"10086",@"name":@"奔驰",@"icon":@"www",@"price":@"80",@"carType":@"奔驰A"}];
        
        [self.navigationController pushViewController:accBuyC animated:YES];
        
    } else if (index == 4) {
        
        CRAccessoriesOfferController *accOfferC = [[CRAccessoriesOfferController alloc] init];
        
        accOfferC.offType = 1;
       
        accOfferC.offerInfoBlock = ^(NSDictionary *dic) {
            
            NSString *message = @"[报价信息]";
            
            [weakSelf sendTextMessage:message withExt:dic];
        };
        [self.navigationController pushViewController:accOfferC animated:YES];
        
    } else if (index == 5) {
        
        CROrderReceiptViewController *orderReceiptViewC = [[CROrderReceiptViewController alloc] init];
        
        orderReceiptViewC.makeOfferBlock = ^(NSDictionary *dic) {
            
            NSString *message = @"[收款信息]";
            
            [weakSelf sendTextMessage:message withExt:dic];
        };
        
        [self.navigationController pushViewController:orderReceiptViewC animated:YES];
    }
     */
}

/** 点击cell方法 */
- (void)messageCellSelected:(id<IMessageModel>)model {
    
    NSDictionary *dict = model.message.ext;
    
    __weak typeof(self) weakSelf = self;
    
    /** 求购消息 */
    if ([CRWantBuyModel isBuyInfo:dict]) {
        
        CRAccessoriesSubmmitController *accBuyC = [[CRAccessoriesSubmmitController alloc] init];
        accBuyC.popType = 2;
//        accBuyC.dic = dict;
        accBuyC.bid = dict[@"infoId"];
        [weakSelf.navigationController pushViewController:accBuyC animated:YES];
        
     /** 报价消息 */
    } else if ([CRWantBuyModel isOfferInfo:dict]) {
        
        CRAccessoriesOfferController *accOfferC = [[CRAccessoriesOfferController alloc] init];
        
       // accOfferC.dic = dict[@"infoId"];
        accOfferC.offType = 1;
        accOfferC.baoId = dict[@"infoId"];
        
        [weakSelf.navigationController pushViewController:accOfferC animated:YES];
        /** 开单收款 */
    } else if ([CRWantBuyModel isCollectionInfo:dict]) {
        
        CROrderReceiptViewController *orderReceiptViewC = [[CROrderReceiptViewController alloc] init];
        
//        orderReceiptViewC.dic = dict;
        [weakSelf.navigationController pushViewController:orderReceiptViewC animated:YES];
        
        /** 商品信息 */
    } else if ([CRWantBuyModel isGoodsInfo:dict]) {
        
        CRProDeatilController *proDetailC = [[CRProDeatilController alloc] init];
        
//        accOfferC.dic = dict;
        [weakSelf.navigationController pushViewController:proDetailC animated:YES];
        
    } else {
        
        [super messageCellSelected:model];
    }
}

/** 发送红包消息
- (void)sendCarPacketMessage:(id<IMessageModel>)model
{
    NSDictionary *dic = [model redpacketMessageModelToDic];
    NSString *message;
    message = [NSString stringWithFormat:@"[%@]%@", model.redpacket.redpacketOrgName, model.redpacket.redpacketGreeting];
    [self sendTextMessage:message withExt:dic];
}
*/

/** 长时间按在某条Cell上的动作 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if ([object conformsToProtocol:NSProtocolFromString(@"IMessageModel")]) {
        id <IMessageModel> messageModel = object;
        NSDictionary *ext = messageModel.message.ext;
        /** 如果是红包，则只显示删除按钮 */
        if ([CRWantBuyModel iscustomInfo:ext]) {
            EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            self.menuIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:EMMessageBodyTypeCmd];
            return NO;
        }
    }
    return [super messageViewController:viewController canLongPressRowAtIndexPath:indexPath];
}

@end
