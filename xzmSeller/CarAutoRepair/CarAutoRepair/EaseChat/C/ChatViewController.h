//
//  ChatViewController.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/16.
//  Copyright © 2017年 Tracy. All rights reserved.
//

@interface ChatViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>


- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;

@end
