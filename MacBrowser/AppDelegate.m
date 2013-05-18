//
//  AppDelegate.m
//  MyOSApp
//
//  Created by kyle on 13-4-2.
//  Copyright (c) 2013年 kyle. All rights reserved.
//

#import "AppDelegate.h"
#import "AppWindowController.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    appWindowController = [[AppWindowController alloc] initWithWindow:nil];
}

@end
