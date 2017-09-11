//
//  CRConversationListController.h
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/16.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "EaseUI.h"

@interface CRConversationListController : EaseConversationListViewController

@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
