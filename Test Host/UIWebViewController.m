//
//  WebViewController.m
//  KIF
//
//  Created by Joe Masilotti on 11/19/14.
//
//

@interface UIWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation UIWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
