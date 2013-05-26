//
//  AppWindowController.h
//  MyOSApp
//
//  Created by kyle on 13-4-2.
//  Copyright (c) 2013年 kyle. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WebViewController.h"

@class  WebView;
@class WebViewController;
@protocol ViewControllerDelegate;

@interface AppWindowController : NSWindowController <NSWindowDelegate, \
                                 ViewControllerDelegate, NSTextDelegate, \
                                 NSControlTextEditingDelegate, NSToolbarDelegate, \
                                 NSToolbarDelegate>
{
    NSTextField* m_urlField;
    WebViewController* m_webViewController;
    
    BOOL m_canGoBack;
    BOOL m_canGoForward;
}

@property (nonatomic, readonly) WebViewController* webViewController;
@end
