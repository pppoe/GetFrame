//
//  GetFrameSelectionView.m
//  GetFrame
//
//  Created by haoxiang on 8/12/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import "GetFrameSelectionView.h"

#define kResizeAreaSize 10

@implementation GetFrameSelectionView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBoxType:NSBoxCustom];
        [self setFillColor:[[NSColor blueColor] colorWithAlphaComponent:0.3f]];
        [self setBorderType:NSLineBorder];
        [self setBorderColor:[NSColor blueColor]];        
    }    
    return self;
}

- (void)dealloc
{
    [resizeArea release];
    [super dealloc];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    NSPoint curPt = [self frame].origin;
    [self setFrameOrigin:NSMakePoint(curPt.x + [theEvent deltaX],
                                     curPt.y - [theEvent deltaY])];
    [targetMoved performSelector:selectorMoved];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [targetRelease performSelector:selectorRelease];
}

- (void)setDragReleaseTarget:(id)theTarget andSelector:(SEL)theSelector {
    targetRelease = theTarget;
    selectorRelease = theSelector;
}

- (void)setDragMovedTarget:(id)theTarget andSelector:(SEL)theSelector {
    targetMoved = theTarget;
    selectorMoved = theSelector;
}

//- (void)setFrame:(NSRect)frameRect {
//    frameRect.size.width = MAX(kResizeAreaSize, frameRect.size.width);
//    frameRect.size.height = MAX(kResizeAreaSize, frameRect.size.height);
//    [super setFrame:frameRect];
//    
//}

@end
