//
//  WKWebView+JHSchemeHandler.h
//  JHURLSchemeHandler
//
//  Created by HaoCold on 2022/5/17.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kCustomScheme @"haocold"
#define kHttps @"https"
#define kHttp @"http"

@interface WKWebView (JHSchemeHandler)

@end

NS_ASSUME_NONNULL_END
