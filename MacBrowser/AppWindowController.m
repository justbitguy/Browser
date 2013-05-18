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

#import "WebViewController.h"

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
@synthesize webViewController = m_webViewController;


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        [self loadWindow];
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
    [self.window setTitle:@"Just Browse All"];
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
    m_backButton = [[[NSButton alloc] initWithFrame:NSMakeRect(0, 0 , BTN_WIDTH, BTN_HEIGHT)] autorelease];
    [m_backButton setTitle:@"<"];
    [m_backButton setTarget:self];
    [m_backButton setAction:@selector(back)];
    
    // forward button.
    m_forwardButton = [[[NSButton alloc] initWithFrame:NSMakeRect(BTN2_X, 0,  BTN_WIDTH, BTN_HEIGHT)] autorelease];
    [m_forwardButton setTitle:@">"];
    [m_forwardButton setTarget:self];
    [m_forwardButton setAction:@selector(forward)];
    
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
    [m_urlField setFont:[NSFont userFontOfSize:18.0]];
    
    // webivew.
    CGFloat windowWidth = self.window.frame.size.width;
    CGFloat windowHeight = self.window.frame.size.height;
    
    NSRect frameRect = NSMakeRect(0, BTN_HEIGHT, windowWidth, windowHeight - BTN_HEIGHT);
    m_webViewController = [[WebViewController alloc] initWithFrame:frameRect];
    WebView* webView = [m_webViewController webView];
    m_webViewController.delegate = self;
    
    [self.window.contentView addSubview:m_backButton];
    [self.window.contentView addSubview:m_forwardButton];
    [self.window.contentView addSubview:button3];
    [self.window.contentView addSubview:button4];
    [self.window.contentView addSubview:m_urlField];
    [self.window.contentView addSubview:webView];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)dealloc
{
    [m_backButton release];
    [m_forwardButton release];
    [m_urlField release];
    m_webViewController.delegate = nil;
    [m_webViewController release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark button callback
- (void)back
{
    if (self.webViewController)
        [self.webViewController back];
}

- (void)forward
{
    if (self.webViewController)
        [self.webViewController forward];
}

- (void)refresh
{
    if (self.webViewController)
        [self.webViewController refresh];
}

- (void)go
{
    NSString* url = m_urlField.stringValue;
    [self.webViewController load:url];
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

#pragma mark - 
#pragma mark ViewControllerDelegate
- (void)setCanGoBack:(BOOL)back canGoForward:(BOOL)forward
{
    [m_backButton setEnabled:back];
    [m_forwardButton setEnabled:forward];
}

- (void)updateURL:(NSString*)url
{
    [m_urlField setStringValue:url];
}

- (void)updateTitle:(NSString*)title
{
    [self.window setTitle:title];
}

@end
