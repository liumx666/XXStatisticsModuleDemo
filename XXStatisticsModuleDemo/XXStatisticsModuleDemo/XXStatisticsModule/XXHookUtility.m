//
//  XXHookUtility.m
//  XXStatisticsModuleDemo
//
//  Created by lmx on 16/5/2.
//  Copyright © 2016年 lmx. All rights reserved.
//

#import <objc/runtime.h>

#import "XXHookUtility.h"

@implementation XXHookUtility

+ (void)swizzlingInClass:(Class)cls OriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    
    Class class = cls;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
