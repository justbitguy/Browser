//
//  AppWindowController.m
//  MyOSApp
//
//  Created by kyle on 13-4-2.
//  Copyright (c) 2013年 kyle. All rights reserved.
//

#import "AppWindowController.h"
#import "WebKit/WebView.h"
#import "WebKit/WebFrame.h"
#import "NSFlippedView.h"

#define BTN_WIDTH 30
#define BTN_HEIGHT 30

#define URLField_WIDTH  400
#define URLField_HEIGHT BTN_HEIGHT

#define BTN2_X BTN_WIDTH
#define BTN3_X (BTN2_X)+(BTN_WIDTH)
#define BTN4_X (BTN3_X)+(BTN_WIDTH)
#define URLField_X (BTN4_X)+(BTN_WIDTH)


@interface AppWindowController ()

@end

@implementation AppWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {

    }
    
    return self;
}


- (void)windowWillLoad
{

}

- (void)loadWindow
{
    // crreate window.
    NSRect rc = NSMakeRect(0, 0, 800, 600);
    NSUInteger uiStyle = NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask;
    NSBackingStoreType backingStoreStyle = NSBackingStoreBuffered;
    self.window = [[NSWindow alloc] initWithContentRect:rc styleMask:uiStyle backing:backingStoreStyle defer:NO];
    [self.window setTitle:@"window!"];
    [self.window makeKeyAndOrderFront:self.window];
    [self.window makeMainWindow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:)
                                                 name:NSWindowDidResizeNotification object:nil];
    
    // create UI.
    [self UI];
}

- (void)UI
{
    // set a flipped view as the content view.
    // just reverse the coordinate system.
    
    NSFlippedView* view = [[[NSFlippedView alloc] initWithFrame:self.window.frame] autorelease];
    [self.window setContentView:view];

    // back button.
    NSButton* button = [[[NSButton alloc] initWithFrame:NSMakeRect(0, 0 , BTN_WIDTH, BTN_HEIGHT)] autorelease];
    [button setTitle:@"<"];
    [button setTarget:self];
    [button setAction:@selector(back)];
    
    // forward button.
    NSButton* button2 = [[[NSButton alloc] initWithFrame:NSMakeRect(BTN2_X, 0,  BTN_WIDTH, BTN_HEIGHT)] autorelease];
    [button2 setTitle:@">"];
    [button2 setTarget:self];
    [button2 setAction:@selector(forward)];
    
    // refresh button.
    NSButton* button3 = [[[NSButton alloc] initWithFrame:NSMakeRect(BTN3_X, 0, BTN_WIDTH, BTN_HEIGHT)] autorelease];
    [button3 setTitle:@"R"];
    [button3 setTarget:self];
    [button3 setAction:@selector(refresh)];
    
    // go button.
    NSButton* button4 = [[[NSButton alloc] initWithFrame:NSMakeRect(BTN4_X, 0, BTN_WIDTH, BTN_HEIGHT)] autorelease];
    [button4 setTitle:@"G"];
    [button4 setTarget:self];
    [button4 setAction:@selector(go)];

    // url field.
    CGFloat width = self.window.frame.size.width - BTN_WIDTH*4;
    m_urlField = [[NSTextField alloc] initWithFrame:NSMakeRect(URLField_X, 0, width, URLField_HEIGHT)];
    
    // webivew.
    CGFloat windowWidth = self.window.frame.size.width;
    CGFloat windowHeight = self.window.frame.size.height;
    
    m_webView = [[WebView alloc] initWithFrame:NSMakeRect(0, BTN_HEIGHT, windowWidth, windowHeight - BTN_HEIGHT)];
    
    [self.window.contentView addSubview:button];
    [self.window.contentView addSubview:button2];
    [self.window.contentView addSubview:button3];
    [self.window.contentView addSubview:button4];
    [self.window.contentView addSubview:m_urlField];
    [self.window.contentView addSubview:m_webView];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark callback
- (void)back
{
    
}

- (void)forward
{

}

- (void)refresh
{

}

- (void)go
{
    NSString* urlString = [NSString stringWithString:m_urlField.stringValue];
    [[m_webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

#pragma mark - 
#pragma mark NSWindowDelegate
- (void)windowDidResize:(NSNotification *)notification;
{
    CGSize winSize = self.window.frame.size;
    CGFloat winWidth = winSize.width;
    CGFloat winHeight = winSize.height;
    
    [m_urlField setFrameSize:NSMakeSize(winWidth - 4*BTN_WIDTH, BTN_HEIGHT)];
    [m_webView setFrameSize:NSMakeSize(winWidth, winHeight)];
    
}
@end
