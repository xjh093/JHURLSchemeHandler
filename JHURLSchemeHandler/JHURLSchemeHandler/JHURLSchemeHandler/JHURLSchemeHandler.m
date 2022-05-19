//
//  JHURLSchemeHandler.m
//  JHURLSchemeHandler
//
//  Created by HaoCold on 2021/5/24.
//

#import "JHURLSchemeHandler.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kLogOpen 1
#if kLogOpen
#define Log(...) NSLog(__VA_ARGS__)
#else
#define Log(...)
#endif

@implementation JHURLSchemeHandler

#pragma mark - WKURLSchemeHandler

/** 开始加载自定义scheme的资源 */
- (void)webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask
{
    Log(@"%s, URL:%@", __func__, urlSchemeTask.request.URL);
    // haocold://index.css
    // haocold://photo1.png
    // haocold://photo2.png
    // haocold://photo3.png
    // https://goobe.io/zh-cn/templates/img/logo-blue-small.png
    
    NSString *fileName = [urlSchemeTask.request.URL.absoluteString lastPathComponent];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    if (data.length) {
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:urlSchemeTask.request.URL
                                                            MIMEType:[self getMimeTypeWithFilePath:path]
                                               expectedContentLength:data.length
                                                    textEncodingName:nil];
        [urlSchemeTask didReceiveResponse:response];
        [urlSchemeTask didReceiveData:data];
        [urlSchemeTask didFinish];
    }else{
        // Load from Net        
        // NSString *url = @"https://avatars.githubusercontent.com/u/7610880";

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlSchemeTask.request.URL];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [self didReceiveResponse:urlSchemeTask response:response];
            [self didReceiveData:urlSchemeTask data:data];
            if (error) {
                [self didFailWithError:urlSchemeTask error:error];
            } else {
                [self didFinish:urlSchemeTask];
            }
        }];
        [dataTask resume];
    }
}

/** 停止加载 */
- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask
{
    [self didFinish:urlSchemeTask];
}

#pragma mark - private

- (NSString *)getMimeTypeWithFilePath:(NSString *)filePath
{
    CFStringRef pathExtension = (__bridge_retained CFStringRef)[filePath pathExtension];
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    CFRelease(pathExtension);

    //The UTI can be converted to a mime type:
    NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
    if (type != NULL) {
        CFRelease(type);
    }
    return mimeType;
}

- (void)didReceiveResponse:(id<WKURLSchemeTask>)urlSchemeTask response:(NSURLResponse *)response
{
    @try {
        [urlSchemeTask didReceiveResponse:response];
        Log(@"didReceiveResponse exception: null");
    } @catch (NSException *exception) {
        Log(@"didReceiveResponse exception: %@", exception);
    }
}

- (void)didReceiveData:(id<WKURLSchemeTask>)urlSchemeTask data:(NSData *)data
{
    @try {
        [urlSchemeTask didReceiveData:data];
        Log(@"didReceiveData exception: null");
    } @catch (NSException *exception) {
        Log(@"didReceiveData exception: %@", exception);
    }
}

- (void)didFinish:(id<WKURLSchemeTask>)urlSchemeTask
{
    @try {
        [urlSchemeTask didFinish];
        Log(@"didFinish exception: null");
    } @catch (NSException *exception) {
        Log(@"didFinish exception: %@", exception);
    }
}

- (void)didFailWithError:(id<WKURLSchemeTask>)urlSchemeTask error:(NSError *)error
{
    @try {
        [urlSchemeTask didFailWithError:error];
        Log(@"didFailWithError exception: null");
    } @catch (NSException *exception) {
        Log(@"didFailWithError exception: %@", exception);
    }
}

@end
