//
//  AppDelegate+Statistics.m
//  XXStatisticsModuleDemo
//
//  Created by lmx on 16/5/2.
//  Copyright © 2016年 lmx. All rights reserved.
//

#import "AppDelegate+Statistics.h"

#import "XXHookUtility.h"

#import "MobClick.h"

#define UMENG_APPKEY @"5655d71de0f55a9d01003446"

@implementation AppDelegate (Statistics)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // when swizzling a class method, use the following;
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(application:didFinishLaunchingWithOptions:);
        SEL swizzledSelector = @selector(swiz_application:didFinishLaunchingWithOptions:);
        [XXHookUtility swizzlingInClass:[self class] OriginalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}

#pragma mark - Method Swizzling

- (BOOL)swiz_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    NSLog(@"%s",__FUNCTION__);
    // 插入代码
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];

    // 继续执行原有方法中的代码
    [self swiz_application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)umengTrack {
    
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
}

@end
