//
//  JHURLSchemeHandler.h
//  JHURLSchemeHandler
//
//  Created by HaoCold on 2021/5/24.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "WKWebView+JHSchemeHandler.h"

NS_ASSUME_NONNULL_BEGIN

#define kCustomScheme @"haocold"

@interface JHURLSchemeHandler : NSObject<WKURLSchemeHandler>

@end

NS_ASSUME_NONNULL_END
