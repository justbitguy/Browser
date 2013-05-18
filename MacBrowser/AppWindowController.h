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
@protocol ViewControllerDelegate;

@interface AppWindowController : NSWindowController <NSWindowDelegate, ViewControllerDelegate>
{
    NSButton* m_backButton;
    NSButton* m_forwardButton;
    NSTextField* m_urlField;
    WebViewController* m_webViewController;
}

@property (nonatomic, readonly) WebViewController* webViewController;
@end
