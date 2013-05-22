//
//  ToolbarItemView.m
//  MacBrowser
//
//  Created by kyle on 13-5-22.
//  Copyright (c) 2013年 kyle. All rights reserved.
//

#import "ToolbarItemView.h"

static NSString*    IconBack    = @"arrow_left";

@implementation ToolbarItemView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
        NSString* imageName = [[NSBundle mainBundle] pathForResource:IconBack ofType:@"png"];
        NSImage* imageObj = [[[NSImage alloc] initWithContentsOfFile:imageName] autorelease];
        [imageObj drawInRect:NSMakeRect(0, 0, 30, 30)
             fromRect:NSZeroRect
            operation:NSCompositeSourceOver
             fraction:1]; 
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"mouseDown");
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"mouseUp");
}
@end
