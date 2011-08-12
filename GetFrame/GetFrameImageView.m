//
//  GetFrameImageView.m
//  GetFrame
//
//  Created by haoxiang on 8/10/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import "GetFrameImageView.h"
#import "GetFrameImageViewDelegate.h"

@implementation GetFrameImageView
@synthesize image = _image;
@synthesize imageRect = _imageRect;
@synthesize originPoint = _originPoint;
@synthesize delegate = _delegate;

- (void)drawRect:(NSRect)dirtyRect {
    
    //< If the Image is smaller than current frame, draw it in the center
    //< Otherwise, use a keep ratio fit drawing mode 
    NSRect viewRect = [self bounds];
    NSRect imageRect = NSMakeRect(0, 0, [self.image size].width, [self.image size].height);
    NSRect finalRect = imageRect;
    if (!NSContainsRect(viewRect, imageRect))
    {        
        float xRatio = viewRect.size.width / imageRect.size.width;
        float yRatio = viewRect.size.height / imageRect.size.height;
        float ratio = MIN(xRatio, yRatio);
        finalRect = NSMakeRect(0, 0, ratio * imageRect.size.width, ratio * imageRect.size.height);        
    }
    
    _imageRect = NSMakeRect(NSMidX(viewRect) - NSMidX(finalRect), NSMidY(viewRect) - NSMidY(finalRect), 
                            finalRect.size.width, finalRect.size.height);
    [self.image drawInRect:_imageRect
                   fromRect:imageRect
                  operation:NSCompositeCopy  
                   fraction:1.0f];
    
    _originPoint = NSMakePoint(NSMinX(_imageRect), NSMaxY(_imageRect));
    
    if ([self.delegate respondsToSelector:@selector(rectRenderFinishedInView:)])
    {
        [self.delegate rectRenderFinishedInView:self];
    }
}

- (void)dealloc
{
    self.image = nil;
    [super dealloc];
}

- (NSPoint)pointFromBasePoint:(NSPoint)basePoint {
    return NSMakePoint(basePoint.x - self.originPoint.x, -(basePoint.y - self.originPoint.y));
}

@end
