//
//  NSFlippedView.m
//  MyOSApp
//
//  Created by kyle on 13-5-17.
//  Copyright (c) 2013年 kyle. All rights reserved.
//

#import "NSFlippedView.h"

@implementation NSFlippedView

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
    // Drawing code here.
    [super drawRect:dirtyRect];
}

- (BOOL)isFlipped
{
    return YES;
}

@end
