//
//  ViewController.m
//  动态添加实例方法和类方法
//
//  Created by 羊谦 on 2017/3/9.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "PPSMyObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self doSomething];
}

- (void)doSomething{
//    [self performSelector:@selector(logInstanceMethod)];
//    [self performSelector:@selector(logMyInfo)];
//    [self setText:@"aaa"];
    [[ViewController class] performSelector:@selector(logClassMethod)];
//    [ViewController logClassMethod];//动态添加类方法
//    [self logInstanceMethod];
}

//- (id)forwardingTargetForSelector:(SEL)aSelector{
//    if (aSelector == @selector(logMyInfo)) {
//        PPSMyObject *myObject = [[PPSMyObject alloc] init];
//        return myObject;
//    }
//    NSLog(@"forwardingTargetForSelector");
//    return [super forwardingTargetForSelector:aSelector];
//}
//
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    NSLog(@"forwardInvocation");
    if ([PPSMyObject instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:[[PPSMyObject alloc] init]];
    }
//    [super forwardInvocation:anInvocation];
}
//
////+(BOOL)resolveInstanceMethod:(SEL)sel{
////    NSLog(@"resolveInstanceMethod");
////    return [super resolveInstanceMethod:sel];
////}
//
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSLog(@"methodSignatureForSelector");
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([PPSMyObject instancesRespondToSelector:aSelector]) {
            signature = [PPSMyObject instanceMethodSignatureForSelector:aSelector];
        }
    }
    
    return signature;
    
//    if ([self respondsToSelector:aSelector]) {
//        return [super methodSignatureForSelector:aSelector];
//    }else{
//        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    }
}


/**
 处理类方法

 @param sel 需要动态添加的方法 @return 是否已经有可实现的方法
 */
+(BOOL)resolveClassMethod:(SEL)sel{
    Class metaClass = objc_getMetaClass(class_getName(self));
    IMP imp = [self instanceMethodForSelector:@selector(myClassMethod)];
    if (sel == @selector(logClassMethod)) {
        class_addMethod(metaClass, sel,imp , "v@:");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

- (void)myClassMethod{
    NSLog(@"我的动态类方法");
}
//
/**
 处理实例方法

 @param sel 需要动态添加的方法
 @return 是否已经有可实现的方法
 */
//+(BOOL)resolveInstanceMethod:(SEL)sel{
//    NSLog(@"resolveInstanceMethod");
//    IMP imp = [self instanceMethodForSelector:@selector(myInstanceMethod)];
//    if (sel == @selector(logInstanceMethod)) {
//        class_addMethod([self class], sel, imp, "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

- (void)myInstanceMethod{
    NSLog(@"我的实例方法");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
