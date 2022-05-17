//
//  ViewController.m
//  JHURLSchemeHandler
//
//  Created by HaoCold on 2021/5/24.
//

#import "ViewController.h"
#import "JHURLSchemeHandler.h"

@interface ViewController ()
@property (nonatomic,  strong) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"WKURLSchemeHandler";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Load" style:UIBarButtonItemStylePlain target:self action:@selector(loadAction)];
    [self.view addSubview:self.webView];
    //[self loadAction];
}

- (void)loadAction
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *string = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    [self.webView loadHTMLString:string baseURL:NULL];
}

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [config setURLSchemeHandler:[[JHURLSchemeHandler alloc] init] forURLScheme:kCustomScheme];
        [config setURLSchemeHandler:[[JHURLSchemeHandler alloc] init] forURLScheme:kHttps];
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    }
    return _webView;
}

@end
