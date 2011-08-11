//
//  GetFrameWinController.m
//  GetFrame
//
//  Created by haoxiang on 8/9/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import "GetFrameWinController.h"
#import "GetFrameImageView.h"

/////////////////////////////////////////////////////////////////////
//< Constants
/////////////////////////////////////////////////////////////////////
#define kMinWinWidth (400)
#define kMinWinHeight (400)

#define kMaxWinWidth (1024)
#define kMaxWinHeight (968)

#define kImagePadding (5)

#define kMaxImageWidth (5000)
#define kMaxImageHeight (5000)

#define kMinImageWidth (16)
#define kMinImageHeight (16)

#define kMinZoomFactor (1.0f)
#define kMaxZoomFactor (8.0f)

@interface GetFrameWinController (Private)

- (void)updateTrackingArea;
- (void)zoomView:(NSView *)view withFactor:(float)factor;

@end

@implementation GetFrameWinController

- (id)init
{
    self = [super initWithWindowNibName:@"GetFrameWinController"];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [[self window] setMinSize:NSMakeSize(kMinWinWidth, kMinWinHeight)];    
    [[self window] setMaxSize:NSMakeSize(kMaxWinWidth, kMaxWinHeight)];    
 
    _orgSize = [_imageView frame].size;
    _zoomFactor = 1.0f;
    
    [_scrollView setDocumentView:_imageView];
    
    _curTrackingArea = [_imageView addTrackingRect:[_imageView bounds]
                                             owner:self
                                          userData:nil
                                      assumeInside:YES];
    
    [_imageView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin];
    
}

- (IBAction)openImage:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setWindowController:self];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    NSInteger status = [openPanel runModal];
    if (status == NSFileHandlingPanelOKButton)
    {
        NSURL *fileURL = [openPanel URL];
        NSImage *image = [[NSImage alloc] initWithContentsOfURL:fileURL];
        if (image)
        {
            [_imageView setImage:image];
            
            [_imageView display];
            
            [self updateTrackingArea];

            [image release];            
        }
    }
}

- (IBAction)modeGetFrame:(id)sender {
    
}

- (IBAction)zoomIn:(id)sender {
    
    _zoomFactor = MIN(kMaxZoomFactor, 2 * _zoomFactor);    
    
    [self zoomView:_imageView withFactor:_zoomFactor];
    
    [self updateTrackingArea];
}

- (IBAction)zoomOut:(id)sender {
    
    _zoomFactor = MAX(kMinZoomFactor, _zoomFactor / 2.0f);    
    
    [self zoomView:_imageView withFactor:_zoomFactor];

    [self updateTrackingArea];
}

/////////////////////////////////////////////////////////////////////
//< Events
/////////////////////////////////////////////////////////////////////
- (void)touchesBeganWithEvent:(NSEvent *)event {
    
}

- (void)touchesMovedWithEvent:(NSEvent *)event {
    
}

- (void)touchesEndedWithEvent:(NSEvent *)event {
    
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [[self window] setAcceptsMouseMovedEvents:YES];
    [[NSCursor crosshairCursor] set];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    NSPoint pt = [theEvent locationInWindow];
    NSPoint newPt = [_imageView convertPointFromBase:pt];
    NSPoint finalPt = [_imageView pointFromBasePoint:newPt];
    NSLog(@"%f %f", finalPt.x, finalPt.y);
}

- (void)mouseDragged:(NSEvent *)theEvent {
    
}

- (void)mouseExited:(NSEvent *)theEvent {
    [[self window] setAcceptsMouseMovedEvents:NO];
    [[NSCursor arrowCursor] set];
}

@end

@implementation GetFrameWinController (Private)

- (void)updateTrackingArea {
    [_imageView removeTrackingRect:_curTrackingArea];
    _curTrackingArea = [_imageView addTrackingRect:[_imageView imageRect]
                                             owner:self
                                          userData:nil
                                      assumeInside:YES];
}

- (void)zoomView:(NSView *)view withFactor:(float)factor {
    NSSize s = [view frame].size;
    NSPoint org = [view frame].origin;
    NSPoint ctrPt = NSMakePoint(org.x + s.width/2.0f, org.y + s.height/2.0f);
    NSSize newSize = NSMakeSize(_orgSize.width * factor, _orgSize.height * factor);
    [[view animator] setFrame:NSMakeRect(ctrPt.x - newSize.width/2.0f, 
                                         ctrPt.y - newSize.height/2.0f,
                                         newSize.width, newSize.height)];
}

@end
