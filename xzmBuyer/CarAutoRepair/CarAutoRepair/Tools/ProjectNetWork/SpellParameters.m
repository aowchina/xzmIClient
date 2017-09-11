//
//  SpellParameters.m
//  HonDoAdmin
//
//  Created by minfo010 on 15/8/24.
//  Copyright (c) 2015年 minfo010. All rights reserved.
//

#import "SpellParameters.h"
#import "NSString+MD5Addition.h"
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if_dl.h>
#import <net/if.h>
#import "UICKeyChainStore.h"

@implementation SpellParameters
//+(NSString*)uuid{
//    CFUUIDRef   puuid = CFUUIDCreate( nil );
//    CFStringRef   uuidString = CFUUIDCreateString( nil, puuid );
//    NSString   * userID = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
//    CFRelease(puuid);
//    CFRelease(uuidString);
//    return userID;
//}

static NSString *uuidKey = @"ModelCenter uuid key";

+ (NSString *)uuid {
    
    NSString *string = [UICKeyChainStore stringForKey:uuidKey];
    
    if (string) {
        
    }else{
        
        UIDevice *currentDevice = [UIDevice currentDevice];
        NSUUID* identifierForVendor = currentDevice.identifierForVendor;
        string = [identifierForVendor UUIDString];
        [UICKeyChainStore setString:string forKey:uuidKey];
        
    }
    
    return string;
    
}

//参数拼接
+ (NSString *) getBasePostString:(NSString *)appid1
{
    NSString *appid = appid1;
    NSString *basePostString = [appid stringByAppendingString:@"*"];
    
//    NSString *macaddress = [self macaddress];
//    NSString *uniqueIdentifier = [macaddress stringFromMD5];
    NSString *uniqueIdentifier = [[SpellParameters uuid] stringFromMD5];

    basePostString = [basePostString stringByAppendingString:uniqueIdentifier];
    basePostString = [basePostString stringByAppendingString:@"*"];
    
    NSDictionary *dic    =   [[NSBundle mainBundle] infoDictionary];//获取info－plist
    NSString *appVersion   =   [dic valueForKey:@"CFBundleVersion"];//获取Bundle Version
    basePostString = [basePostString stringByAppendingString:appVersion];
    basePostString = [basePostString stringByAppendingString:@"*"];
    
    NSString *systemVersion   =   [[UIDevice currentDevice] systemVersion];//系统版本
    basePostString = [basePostString stringByAppendingString:@"ios"];
    basePostString = [basePostString stringByAppendingString:systemVersion];
    basePostString = [basePostString stringByAppendingString:@"*"];
    
    basePostString = [basePostString stringByAppendingString:@"apple"];
    basePostString = [basePostString stringByAppendingString:@"*"];
    //[[[UIDevice currentDevice] systemVersion] floatValue];
    NSString *systemModel    =   [[UIDevice currentDevice] model];//是iphone 还是 ipad
    basePostString = [basePostString stringByAppendingString:systemModel];
    basePostString = [basePostString stringByAppendingString:@"*"];
    
    basePostString = [basePostString stringByAppendingString:systemVersion];
    basePostString = [basePostString stringByAppendingString:@"*"];
    
    //
    basePostString = [basePostString stringByAppendingString:[SpellParameters uuid]];
    return basePostString;
    
}

//取设备的MAC地址
+ (NSString *) macaddress
{
    
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

@end
