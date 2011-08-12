//
//  GetFrameSelectionView.m
//  GetFrame
//
//  Created by haoxiang on 8/12/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import "GetFrameSelectionView.h"


@implementation GetFrameSelectionView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBoxType:NSBoxCustom];
        [self setFillColor:[[NSColor blueColor] colorWithAlphaComponent:0.6f]];
        [self setBorderType:NSLineBorder];
        [self setBorderColor:[NSColor blueColor]];
    }    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    NSPoint curPt = [self frame].origin;
    [self setFrameOrigin:NSMakePoint(curPt.x + [theEvent deltaX],
                                     curPt.y - [theEvent deltaY])];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [target performSelector:selector];
}

- (void)setDragReleaseTarget:(id)theTarget andSelector:(SEL)theSelector {
    target = theTarget;
    selector = theSelector;
}

@end
