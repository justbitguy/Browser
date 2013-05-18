//
//  AppWindowController.h
//  MyOSApp
//
//  Created by kyle on 13-4-2.
//  Copyright (c) 2013年 kyle. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class  WebView;
@class WebViewController;

@interface AppWindowController : NSWindowController <NSWindowDelegate>
{
    WebView* m_webView;
    NSTextField* m_urlField;
    WebViewController* m_webViewController;
}

@end
