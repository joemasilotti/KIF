//
//  WebViewController.m
//  KIF
//
//  Created by Joe Masilotti on 11/19/14.
//
//

#import <WebKit/WebKit.h>

@interface WKWebViewController : UIViewController

@end

@implementation WKWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 200.0f) configuration:configuration];
    [self.view addSubview:webView];

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
