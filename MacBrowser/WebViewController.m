//
//  WebViewController.m
//  MyOSApp
//
//  Created by kyle on 13-5-18.
//  Copyright (c) 2013年 kyle. All rights reserved.
//

#import "WebViewController.h"
#import "WebKit/WebView.h"
#import "WebKit/WebFrame.h"
#import "WebKit/WebFrameLoadDelegate.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webView = m_webView;
@synthesize delegate;

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super init];
    if (self)
    {
        [self createWebView:frameRect];
    }
    
    return self;
}

- (void)createWebView:(NSRect)frameRect
{
    m_webView = [[WebView alloc] initWithFrame:frameRect];
    [m_webView setFrameLoadDelegate:self];
}

- (void)dealloc
{
    [m_webView release];
    [super dealloc];
}

#pragma mark -
#pragma mark webview interface
- (void)load:(NSString*)url
{
    NSURL* URL = nil;
    
    NSRange range = [url rangeOfString:@"http" options:NSCaseInsensitiveSearch];
    // not starts with "http"
    if (range.location == NSNotFound)
    {
        NSMutableString* httpString = [NSMutableString stringWithString:@"http://"];
        [httpString appendString:url];
        URL = [NSURL URLWithString:httpString];
    }
    else
    {
        URL = [NSURL URLWithString:url];
    }
    
    [self loadURL:URL];
}


- (void)loadURL:(NSURL*)URL
{
    [[m_webView mainFrame] loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)refresh
{
    [[m_webView mainFrame] reload];
}

- (void)back
{
    [m_webView goBack];
}

- (void)forward
{
    [m_webView goForward];
}

#pragma mark -
#pragma mark WebFrameLoadDelegate methods

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    if ([sender mainFrame] == frame)
    {
        [self.delegate setCanGoBack:[sender canGoBack] canGoForward:[sender canGoForward]];
    }
}

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    if ([sender mainFrame] == frame)
    {
        [self.delegate updateURL:[sender mainFrameURL]];
    }
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame;
{
   if ([sender mainFrame] == frame)
   {
       [self.delegate updateTitle:title];
   }
}

@end
