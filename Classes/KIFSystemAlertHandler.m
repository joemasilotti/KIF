//
//  KIFSystemAlertHandler.m
//  KIF
//
//  Created by Joe Masilotti on 12/1/14.
//
//

#import "KIFSystemAlertHandler.h"
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

@implementation KIFSystemAlertHandler

+ (void)acknowledgeSystemAlert {
    // Dynamically link the private UIAutomation framework
    dlopen([@"/Developer/Library/PrivateFrameworks/UIAutomation.framework/UIAutomation" fileSystemRepresentation], RTLD_LOCAL);

    // Directly accessing these class methods cause linker errors
    Class Target = NSClassFromString(@"UIATarget");
    Class NilElement = NSClassFromString(@"UIAElementNil");

    // Keep trying until the accessibility server starts up (it takes a little while on iOS 7)
    UIAApplication *app = nil;
    while (!app) {
        @try {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];

            UIATarget *target = [Target localTarget];
            app = target.frontMostApp;
            UIAAlert *alert = app.alert;
            [[alert.buttons lastObject] tap];
        }
        @catch (NSException *exception) { }
        @finally { }
    }

    // Run until the alert is dismissed
    while (![app.alert isKindOfClass:NilElement]) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    }
}

@end
