//
//  WebViewController.h
//  MyOSApp
//
//  Created by kyle on 13-5-18.
//  Copyright (c) 2013年 kyle. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WebKit/WebFrameLoadDelegate.h"

@class WebView;

@protocol ViewControllerDelegate <NSObject>
- (void)setCanGoBack:(BOOL)back canGoForward:(BOOL)forward;
- (void)updateURL:(NSString*)url;
- (void)updateTitle:(NSString*)title;
@end

@interface WebViewController : NSViewController
{
    WebView* m_webView;
}

- (id)initWithFrame:(NSRect)frameRect;

// web methods
- (void)load:(NSString*)url;
- (void)refresh;
- (void)back;
- (void)forward;

@property (nonatomic, readonly) WebView* webView;
@property (nonatomic, assign) id<ViewControllerDelegate> delegate;

@end
