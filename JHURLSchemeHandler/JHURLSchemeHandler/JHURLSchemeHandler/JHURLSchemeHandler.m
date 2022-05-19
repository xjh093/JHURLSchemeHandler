//
//  JHURLSchemeHandler.m
//  JHURLSchemeHandler
//
//  Created by HaoCold on 2021/5/24.
//

#import "JHURLSchemeHandler.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation JHURLSchemeHandler

#pragma mark - WKURLSchemeHandler

/** 开始加载自定义scheme的资源 */
- (void)webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask
{
    NSLog(@"%s, URL:%@", __func__, urlSchemeTask.request.URL);
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
        
        NSLog(@"Load from Net");
        
        NSString *url = @"https://avatars.githubusercontent.com/u/7610880";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [urlSchemeTask didReceiveResponse:response];
            [urlSchemeTask didReceiveData:data];
            if (error) {
                [urlSchemeTask didFailWithError:error];
            } else {
                [urlSchemeTask didFinish];
            }
        }];
        [dataTask resume];
    }
}

/** 停止加载 */
- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask
{

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

@end
