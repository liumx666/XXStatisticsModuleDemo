//
//  XXHookUtility.h
//  XXStatisticsModuleDemo
//
//  Created by lmx on 16/5/2.
//  Copyright © 2016年 lmx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXHookUtility : NSObject

///  勾住某个类的方法
///
///  @param cls              被勾住的类
///  @param originalSelector 被勾住的方法
///  @param swizzledSelector 在被勾住的方法中插入代码的方法
+ (void)swizzlingInClass:(Class)cls OriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
