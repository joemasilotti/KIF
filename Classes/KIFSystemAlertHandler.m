//
//  KIFSystemAlertHandler.m
//  KIF
//
//  Created by Joe Masilotti on 12/1/14.
//
//

#import "KIFSystemAlertHandler.h"
#import "KIFTestActor.h"
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

    NSTimeInterval time = 0, tick = 0.1f;

    // Keep trying until the accessibility server starts up (it takes a little while on iOS 7)
    UIAApplication *app = nil;
    while (!app) {
        @try {
            UIATarget *target = [Target localTarget];
            app = target.frontMostApp;
        }
        @catch (NSException *exception) { }
        @finally {
            if (time >= [KIFTestActor defaultTimeout]) {
//- (void)failWithError:(NSError *)error stopTest:(BOOL)stopTest
            }
            NSAssert(time < [KIFTestActor defaultTimeout], @"Timed out waiting for accessibility server to start");
        }
    }

    UIAAlert *alert = app.alert;
    NSAssert(![alert isKindOfClass:NilElement], @"Could not find alert");
    [[alert.buttons lastObject] tap];

    // Run until the alert is dismissed
    time = 0;
    while (![app.alert isKindOfClass:NilElement]) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:tick]];
        time += tick;

        NSAssert(time < [KIFTestActor defaultTimeout], @"Timed out waiting for alert to be dismissed");
    }
}

@end
