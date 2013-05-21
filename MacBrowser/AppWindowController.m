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

static NSString*    IconBack    = @"arrow_left";
static NSString*    IconForward = @"arrow_right";
static NSString*    IconRefresh = @"refresh_red";

static NSString* 	MacBrowserToolbarIdentifier     = @"MacBrowser Toolbar Identifier";
static NSString*	BackToolbarItemIdentifier 	    = @"Back Toolbar Item Identifier";
static NSString*	ForwardToolbarItemIdentifier 	= @"Forward Toolbar Item Identifier";
static NSString*	RefreshToolbarItemIdentifier 	= @"Refresh Toolbar Item Identifier";
static NSString*	URLToolbarItemIdentifier 	    = @"URL Toolbar Item Identifier";
static NSString*	LoadToolbarItemIdentifier 	    = @"Load Toolbar Item Identifier";

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:NSTextDidEndEditingNotification object:m_urlField];
    
    m_canGoBack = NO;
    m_canGoForward = NO;
    
    [self setupViewController];
    [self setupToolbar];
    [self go];
}

- (void) setupViewController
{
    // webivew.
    CGFloat windowWidth = self.window.frame.size.width;
    CGFloat windowHeight = self.window.frame.size.height;
    
    NSRect frameRect = NSMakeRect(0, BTN_HEIGHT, windowWidth, windowHeight - BTN_HEIGHT);
    m_webViewController = [[WebViewController alloc] initWithFrame:frameRect];
    WebView* webView = [m_webViewController webView];
    [self.window.contentView addSubview:webView];
    m_webViewController.delegate = self;
}

- (void) setupToolbar {
    // Create a new toolbar instance, and attach it to our document window
    NSToolbar *toolbar = [[[NSToolbar alloc] initWithIdentifier: MacBrowserToolbarIdentifier] autorelease];
    
    // Set up toolbar properties: Allow customization, give a default display mode, and remember state in user defaults
    [toolbar setAllowsUserCustomization: YES];
    [toolbar setAutosavesConfiguration: YES];
    [toolbar setDisplayMode: NSToolbarDisplayModeIconOnly];
    
    // We are the delegate
    [toolbar setDelegate: self];
    
    // Attach the toolbar to the document window
    [self.window setToolbar: toolbar];
}


- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [m_urlField release];
    m_webViewController.delegate = nil;
    [m_webViewController release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark button callback
- (void)back:(id)sender
{
    if (self.webViewController)
        [self.webViewController back];
}

- (void)forward:(id)sender
{
    if (self.webViewController)
        [self.webViewController forward];
}

- (void)refresh:(id)sender
{
    if (self.webViewController)
        [self.webViewController refresh];
}

- (void)go:(id)sender
{
    [self go];
}

- (void)go
{
    NSString* url = m_urlField.stringValue;
    [self.webViewController load:url];
}

- (void)url:(id)sender
{
    // todo.
}

#pragma mark - 
#pragma mark NSWindowDelegate
- (void)windowDidResize:(NSNotification *)notification;
{
    CGSize winSize = self.window.frame.size;
    CGFloat winWidth = winSize.width;
    CGFloat winHeight = winSize.height;
    
    [m_urlField setFrameSize:NSMakeSize(winWidth - 4*BTN_WIDTH, BTN_HEIGHT)];
    [self.webViewController setWebViewFrame:NSMakeRect(0, BTN_HEIGHT, winWidth, winHeight)];
}

#pragma mark - 
#pragma mark NSTextFieldDelegate
- (void)textDidEndEditing:(NSNotification *)aNotification
{
   id object =  [[aNotification userInfo] objectForKey:@"NSTextMovement"];
   if ([object intValue] == NSReturnTextMovement)
   {
       [self go];
   }
}

#pragma mark -
#pragma mark NSToolbarDlegate
- (NSToolbarItem *) toolbar: (NSToolbar *)toolbar itemForItemIdentifier: (NSString *) itemIdent willBeInsertedIntoToolbar:(BOOL) willBeInserted {
    // Required delegate method:  Given an item identifier, this method returns an item
    // The toolbar will use this method to obtain toolbar items that can be displayed in the customization sheet, or in the toolbar itself
    NSToolbarItem *toolbarItem = nil;
    
    if ([itemIdent isEqual: BackToolbarItemIdentifier])
    {
        toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdent] autorelease];
        
        // Set the text label to be displayed in the toolbar and customization palette
        [toolbarItem setLabel: @"Back"];
        [toolbarItem setPaletteLabel: @"Back"];
        
        // Set up a reasonable tooltip, and image   Note, these aren't localized, but you will likely want to localize many of the item's properties
        [toolbarItem setToolTip: @"Go Back"];
        
        NSString* imageName = [[NSBundle mainBundle] pathForResource:IconBack ofType:@"png"];
        NSImage* imageObj = [[[NSImage alloc] initWithContentsOfFile:imageName] autorelease];
        [toolbarItem setImage: imageObj];
        
        // Tell the item what message to send when it is clicked
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(back:)];
    }
    else if ([itemIdent isEqual: ForwardToolbarItemIdentifier])
    {

        toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdent] autorelease];
        
        // Set the text label to be displayed in the toolbar and customization palette
        [toolbarItem setLabel: @"Forward"];
        [toolbarItem setPaletteLabel: @"Forward"];
        
        // Set up a reasonable tooltip, and image   Note, these aren't localized, but you will likely want to localize many of the item's properties
        [toolbarItem setToolTip: @"Go Forward"];
        
        NSString* imageName = [[NSBundle mainBundle] pathForResource:IconForward ofType:@"png"];
        NSImage* imageObj = [[[NSImage alloc] initWithContentsOfFile:imageName] autorelease];
        [toolbarItem setImage: imageObj];
        
        // Tell the item what message to send when it is clicked
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(forward:)];
    }
    else if ([itemIdent isEqual: RefreshToolbarItemIdentifier])
    {
        
        toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdent] autorelease];
        
        // Set the text label to be displayed in the toolbar and customization palette
        [toolbarItem setLabel: @"Refresh"];
        [toolbarItem setPaletteLabel: @"Refresh"];
        
        // Set up a reasonable tooltip, and image   Note, these aren't localized, but you will likely want to localize many of the item's properties
        [toolbarItem setToolTip: @"Refresh"];
        
        NSString* imageName = [[NSBundle mainBundle] pathForResource:IconRefresh ofType:@"png"];
        NSImage* imageObj = [[[NSImage alloc] initWithContentsOfFile:imageName] autorelease];
        [toolbarItem setImage: imageObj];
        
        // Tell the item what message to send when it is clicked
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(refresh:)];
    }
    else if ([itemIdent isEqual: URLToolbarItemIdentifier])
    {
        
        toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdent] autorelease];
        
        // Set the text label to be displayed in the toolbar and customization palette
        [toolbarItem setLabel: @"URL"];
        [toolbarItem setPaletteLabel: @"URL"];
        
        // Set up a reasonable tooltip, and image   Note, these aren't localized, but you will likely want to localize many of the item's properties
        [toolbarItem setToolTip: @"input url"];
        
        CGFloat width = self.window.frame.size.width - BTN_WIDTH*4;
        m_urlField = [[NSTextField alloc] initWithFrame:NSMakeRect(URLField_X, 0, width, URLField_HEIGHT)];
        [m_urlField setFont:[NSFont userFontOfSize:18.0]];
        [m_urlField setTextColor:[NSColor colorWithSRGBRed:30.0/255 green:50.0/255 blue:80.0/255 alpha:1.0]];
        [m_urlField setStringValue:@"http://www.baidu.com"];

        [toolbarItem setView:m_urlField];
        [toolbarItem setMinSize:NSMakeSize(30, NSHeight([m_urlField frame]))];
        [toolbarItem setMaxSize:NSMakeSize(1232,NSHeight([m_urlField frame]))];
        // Tell the item what message to send when it is clicked
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(url:)];
    }
    else if ([itemIdent isEqual: LoadToolbarItemIdentifier])
    {
        
        toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdent] autorelease];
        
        // Set the text label to be displayed in the toolbar and customization palette
        [toolbarItem setLabel: @"Load"];
        [toolbarItem setPaletteLabel: @"Load"];
        
        // Set up a reasonable tooltip, and image   Note, these aren't localized, but you will likely want to localize many of the item's properties
        [toolbarItem setToolTip: @"Load"];
        
        NSString* imageName = [[NSBundle mainBundle] pathForResource:@"load" ofType:@"png"];
        NSImage* imageObj = [[[NSImage alloc] initWithContentsOfFile:imageName] autorelease];
        [toolbarItem setImage: imageObj];
        
        // Tell the item what message to send when it is clicked
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(go:)];
    }
    else
    {
        // itemIdent refered to a toolbar item that is not provide or supported by us or cocoa
        // Returning nil will inform the toolbar this kind of item is not supported
        toolbarItem = nil;
    }
    
    return toolbarItem;
}

- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *) toolbar {
    // Required delegate method:  Returns the ordered list of items to be shown in the toolbar by default
    // If during the toolbar's initialization, no overriding values are found in the user defaults, or if the
    // user chooses to revert to the default items this set will be used
    return [NSArray arrayWithObjects: BackToolbarItemIdentifier,
                                      ForwardToolbarItemIdentifier,
                                      RefreshToolbarItemIdentifier,
                                      URLToolbarItemIdentifier,
                                      LoadToolbarItemIdentifier,
                                      nil];
}

- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar *) toolbar {
    // Required delegate method:  Returns the list of all allowed items by identifier.  By default, the toolbar
    // does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed
    // The set of allowed items is used to construct the customization palette
    return [NSArray arrayWithObjects: 	BackToolbarItemIdentifier,
                                        ForwardToolbarItemIdentifier,
                                        RefreshToolbarItemIdentifier,
                                        LoadToolbarItemIdentifier,
                                        NSToolbarPrintItemIdentifier,
                                        NSToolbarShowColorsItemIdentifier,
                                        NSToolbarShowFontsItemIdentifier,
                                        NSToolbarCustomizeToolbarItemIdentifier,
                                        NSToolbarFlexibleSpaceItemIdentifier,
                                        NSToolbarSpaceItemIdentifier,
                                        NSToolbarSeparatorItemIdentifier, nil];
}

- (void) toolbarWillAddItem: (NSNotification *) notif {
    // Optional delegate method:  Before an new item is added to the toolbar, this notification is posted.
    // This is the best place to notice a new item is going into the toolbar.  For instance, if you need to
    // cache a reference to the toolbar item or need to set up some initial state, this is the best place
    // to do it.  The notification object is the toolbar to which the item is being added.  The item being
    // added is found by referencing the @"item" key in the userInfo
    NSToolbarItem *addedItem = [[notif userInfo] objectForKey: @"item"];
    if ([[addedItem itemIdentifier] isEqual: NSToolbarPrintItemIdentifier]) {
        [addedItem setToolTip: @"Print Your Document"];
        [addedItem setTarget: self];
    }
}

- (void) toolbarDidRemoveItem: (NSNotification *) notif {
    // Optional delegate method:  After an item is removed from a toolbar, this notification is sent.   This allows
    // the chance to tear down information related to the item that may have been cached.   The notification object
    // is the toolbar from which the item is being removed.  The item being added is found by referencing the @"item"
    // key in the userInfo

}

- (BOOL) validateToolbarItem: (NSToolbarItem *) toolbarItem {
    // Optional method:  This message is sent to us since we are the target of some toolbar item actions
    // (for example:  of the save items action)
    BOOL enable = NO;
    if ([[toolbarItem itemIdentifier] isEqual: BackToolbarItemIdentifier]) {
        enable = m_canGoBack;
    } else if ([[toolbarItem itemIdentifier] isEqual: ForwardToolbarItemIdentifier]) {
        enable = m_canGoForward;
    } else if ([[toolbarItem itemIdentifier] isEqual: RefreshToolbarItemIdentifier]){
        enable = YES;
    }else if ([[toolbarItem itemIdentifier] isEqual: LoadToolbarItemIdentifier]){
        enable = YES;
    }
    
    return enable;
}

- (BOOL) validateMenuItem: (NSMenuItem *) item {
    BOOL enabled = YES;
    
    if ([item action]==@selector(searchMenuFormRepresentationClicked:) || [item action]==@selector(searchUsingSearchPanel:)) {
//        enabled = [self validateToolbarItem: activeSearchItem];
    }
    
    return enabled;
}



#pragma mark - 
#pragma mark ViewControllerDelegate
- (void)setCanGoBack:(BOOL)back canGoForward:(BOOL)forward
{
    m_canGoBack = back;
    m_canGoForward = forward;
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
