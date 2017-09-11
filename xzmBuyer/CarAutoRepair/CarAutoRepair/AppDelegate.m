//
//  AppDelegate.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/5/15.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "CRLoginController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"

#import "JPUSHService.h"

@interface AppDelegate () <EMChatManagerDelegate,UNUserNotificationCenterDelegate,WXApiDelegate,JPUSHRegisterDelegate>
//JPUSHRegisterDelegate

@property (nonatomic, assign) NSInteger bagde;
@property (nonatomic, assign) NSInteger orderCount;

/** receiveType */
@property (nonatomic, assign) NSInteger receiveType;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    application.applicationIconBadgeNumber = 0;
    
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error)
     {
         if (granted)
         {
             
             [[UIApplication sharedApplication] registerForRemoteNotifications];
         }
     }];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CRLoginController alloc] init]];
    
    [[UIButton appearance] setExclusiveTouch:YES];
    
    [UITextField appearance].tintColor = kTextFieldColor;
    [UITextView appearance].tintColor = kTextFieldColor;
    
    //防止键盘遮挡
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    //注册微信
    [WXApi registerApp:kWXAppID];
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     */
    [ShareSDK registerApp:@"iosv1101" activePlatforms:@[@(SSDKPlatformTypeWechat)] onImport:^(SSDKPlatformType platformType) {
        
        switch (platformType) {
                
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
         switch (platformType) {
             case SSDKPlatformTypeWechat: [appInfo SSDKSetupWeChatByAppId:@"wx4d9f692ef2985664" appSecret:@"962833e0cf018162fd5be64d2a9a10ab"];
                 break;
             default:
                 break;
         }
     }];
    
    /** 极光推送 */
    
    [JPUSHService setupWithOption:launchOptions appKey:@"88f2fc5d31caf5615c643114" channel:@"App Store" apsForProduction:NO];
    
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert) categories:nil];
    }
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert |JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    
    /** 注册环信 */
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"1124170630115118#carautorepair" apnsCertName:@"" otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
//    生产  buyCarPro 开发  carbuy
    
    //iOS8以上 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    //    设置推送显示详情
    EMPushOptions *optionsStyleSet = [[EMClient sharedClient] pushOptions];
    optionsStyleSet.displayStyle = EMPushDisplayStyleSimpleBanner; // 显示消息内容
    // options.displayStyle == EMPushDisplayStyleSimpleBanner // 显示“您有一条新消息”
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    // 更新配置到服务器，该方法为同步方法，如果需要，请放到单独线程
    /** 异步 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[EMClient sharedClient] updatePushOptionsToServer];
        
        /** 获取全局 APNS 配置 */
        EMError *error = nil;
        //    EMPushOptions *options = [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
        [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
        
    });
    
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings

{
    
    [application registerForRemoteNotifications];
    
}

/**
 *  时刻监听信息接受
 *
 *  @param aMessages 环信消息体
 */

- (void)didReceiveMessages:(NSArray *)aMessages {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"chatBagde"] == nil) {
        self.bagde = 0;
    } else {
        self.bagde = [[[NSUserDefaults standardUserDefaults] objectForKey:@"chatBagde"] integerValue];
    }
    self.bagde++;
    /**
     创建本地通知
     */
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    //设置调用时间
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];//通知触发的时间，1s以后
    //    notification.repeatInterval = 0;//通知重复次数
    //设置通知属性
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:aMessages[0]];
    notification.alertTitle = @"浙江心之盟";
    notification.alertBody = model.text; //通知主体
    notification.applicationIconBadgeNumber = self.bagde;//应用程序图标右上角显示的消息数
    notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
    notification.alertLaunchImage = @"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
    notification.soundName = @"msg.caf";//通知声音（需要真机才能听到声音）
    //    notification.userInfo = @{@"userid":model.from};
    
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EMMessage" object:[NSString stringWithFormat:@"%ld",(long)self.bagde]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)self.bagde] forKey:@"chatBagde"];
}


// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    /** 环信.极光消息注册 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //获得APNS返回的设备标识符deviceToken
       [JPUSHService registerDeviceToken:deviceToken];
        
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
        
    });
    
    
    NSArray *array = @[[JPUSHService registrationID]];
    
    [[DDQProjectNetWork sharedNetWork] asyncAFNPOST:[BaseURL stringByAppendingString:@"order/SaveJpush.php"] Param:array Success:^(id responseObjc, NSError *codeErr) {
        
    } Failure:^(NSError *netErr) {
        
    }];

}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}

- (void)easemobApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    [self easemobApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    //    if (_mainController) {
    //        [_mainController didReceiveUserNotification:response.notification];
    //    }
    completionHandler();
}

/*
// 打印收到的apns信息
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")  message:str  delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
    [alert show];
    
}
*/


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    self.receiveType = 1;
    
    /** 前台收到通知 */
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
//        if ([userInfo[@"type"] isEqualToString:@"jpush"]) {
        
           [JPUSHService handleRemoteNotification:userInfo];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"wantBagde"] == nil) {
                self.orderCount = 0;
            } else {
                self.orderCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"wantBagde"] integerValue];
            }
            self.orderCount++;
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)self.orderCount] forKey:@"wantBagde"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveWantInfo" object:@{@"value":@(self.orderCount).stringValue}];
            
            completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
            
//        }
        
    }
    
    completionHandler(UNNotificationPresentationOptionBadge);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
//        if ([userInfo[@"type"] isEqualToString:@"jpush"]) {
            [JPUSHService handleRemoteNotification:userInfo];
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"wantBagde"] == nil) {
                self.orderCount = 0;
            } else {
                self.orderCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"wantBagde"] integerValue];
            }
            if (self.receiveType != 1) {
                self.orderCount++;
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)self.orderCount] forKey:@"wantBagde"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveWantInfo" object:@{@"value":@(self.orderCount).stringValue}];
//        }
    }
    
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    self.receiveType = 0;
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    self.receiveType = 0;
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
}

#pragma mark - 系统的回调
/** 如若要支持低版本还是得实现这个方法 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AL" object:resultDic];
            
        }];
        
    }
    
    // 其他如支付等SDK的回调
    return [WXApi handleOpenURL:url delegate:self] || YES;
}

/** iOS9.0以后的新api */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AL" object:resultDic];
            
        }];
    }
    // 其他如支付等SDK的回调
    return [WXApi handleOpenURL:url delegate:self] || YES;
}

#pragma mark - 微信代理
- (void)onResp:(BaseResp*)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) {//是支付请求
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WX" object:resp];
        
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
