//
//  UIViewController+Statistics.m
//  XXStatisticsModuleDemo
//
//  Created by lmx on 16/5/2.
//  Copyright © 2016年 lmx. All rights reserved.
//

#import "UIViewController+Statistics.h"

#import "XXHookUtility.h"

#import "MobClick.h"



@implementation UIViewController (Statistics)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // when swizzling a class method, use the following;
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(swiz_viewWillAppear:);
        [XXHookUtility swizzlingInClass:[self class] OriginalSelector:originalSelector swizzledSelector:swizzledSelector];
        
        SEL originalSelector2 = @selector(viewWillDisappear:);
        SEL swizzledSelector2 = @selector(swiz_viewWillDisappear:);
        [XXHookUtility swizzlingInClass:[self class] OriginalSelector:originalSelector2 swizzledSelector:swizzledSelector2];
    });
}

#pragma mark - Method Swizzling

- (void)swiz_viewWillAppear:(BOOL)animated{
    
    // 插入需要执行的代码
    [self inject_viewWillAppear];
    
    // 不能干扰原来的代码流程，插入代码结束后要让本来该执行的代码继续执行
    [self swiz_viewWillAppear:animated];
}

- (void)swiz_viewWillDisappear:(BOOL)animated{
    
    // 插入需要执行的代码
    [self inject_viewWillDisappear];
    
    // 不能干扰原来的代码流程，插入代码结束后要让本来该执行的代码继续执行
    [self swiz_viewWillDisappear:animated];
}

#pragma mark - 统计代码
// 利用hook 注入代码(比如插入统计代码)
- (void)inject_viewWillAppear{
    
    NSString * pageID = [self pageEventID];
    if (pageID) {
        [MobClick beginLogPageView:pageID];
        
    }
    
}
- (void)inject_viewWillDisappear{

    NSString * pageID = [self pageEventID];
    if (pageID) {
        [MobClick endLogPageView:pageID];
    }
    NSLog(@"%s",__FUNCTION__);
}

- (NSString *)pageEventID{
    
    NSDictionary * configDict = [self dictionaryFromUserStatisticsConfigPlist];
    NSString * selfClassName = NSStringFromClass([self class]);
    if (configDict != nil) {
        return configDict[@"UIViewControllers"][selfClassName];
    }
    return nil;
}

- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist{
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"XXStatisticsModule" ofType:@"plist"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dict;
}

@end
