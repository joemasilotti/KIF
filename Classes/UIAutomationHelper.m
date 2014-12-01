//
//  UIAutomationHelper.m
//  KIF
//
//  Created by Joe Masilotti on 12/1/14.
//
//

#import "UIAutomationHelper.h"
#include <dlfcn.h>

@interface UIAElement : NSObject <NSCopying>
- (void)tap;
@end

@interface UIAAlert : UIAElement
- (NSArray *)buttons;
@end

@interface UIAApplication : UIAElement
- (UIAAlert *)alert;
@end

@interface UIATarget : UIAElement
+ (UIATarget *)localTarget;
- (UIAApplication *)frontMostApp;
@end

@implementation UIAutomationHelper

+ (UIAutomationHelper *)sharedHelper
{
    static dispatch_once_t once;
    static UIAutomationHelper *sharedObserver = nil;
    dispatch_once(&once, ^{
        sharedObserver = [[self alloc] init];
    });
    return sharedObserver;
}

+ (void)linkAutomationFramework {
    [[self sharedHelper] linkAutomationFramework];
}

- (void)linkAutomationFramework {
    dlopen([@"/Developer/Library/PrivateFrameworks/UIAutomation.framework/UIAutomation" fileSystemRepresentation], RTLD_LOCAL);
}

+ (void)acknowledgeSystemAlert {
    [[self sharedHelper] acknowledgeSystemAlert];
}

- (void)acknacknowledgeSystemAlert {

}

@end
