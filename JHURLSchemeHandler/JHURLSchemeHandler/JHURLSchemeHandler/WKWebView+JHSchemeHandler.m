//
//  WKWebView+JHSchemeHandler.m
//  JHURLSchemeHandler
//
//  Created by HaoCold on 2022/5/17.
//

#import "WKWebView+JHSchemeHandler.h"
#import <objc/runtime.h>

@implementation WKWebView (JHSchemeHandler)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method old = class_getClassMethod(self, @selector(handlesURLScheme:));
        Method new = class_getClassMethod(self, @selector(jhhandlesURLScheme:));
        method_exchangeImplementations(old, new);
    });
}

+ (BOOL)jhhandlesURLScheme:(NSString *)urlScheme
{
    if ([urlScheme isEqualToString:kCustomScheme] ||
        [urlScheme isEqualToString:kHttps] ||
        [urlScheme isEqualToString:kHttp]
        ) {
        return NO;
    }
    return [self handlesURLScheme:urlScheme];
}

@end
