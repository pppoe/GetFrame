//
//  GetFrameWinController.m
//  GetFrame
//
//  Created by haoxiang on 8/9/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import "GetFrameWinController.h"
#import "GetFrameSelectionView.h"
#import "GetFrameImageView.h"
#import "GetFrameImageViewDelegate.h"

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

@interface GetFrameWinController (Private) <GetFrameImageViewDelegate>

- (void)selectionMoved;
- (void)updateTrackingArea;
- (void)zoomView:(NSView *)view withFactor:(float)factor;

@end

@implementation GetFrameWinController
@synthesize trackingMode = _trackingMode;
@synthesize curRect = _curRect;
@synthesize curPoint = _curPoint;

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
    [_selectionView release];
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
    
    [_imageView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin];    
    _imageView.delegate = self;    
    
    _selectionView = [[GetFrameSelectionView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];    
    [_selectionView setDragReleaseTarget:self andSelector:@selector(selectionMoved)];
    [_imageView addSubview:_selectionView];
    [_selectionView setHidden:YES];
}

- (void)setTrackingMode:(EnumTrackingMode)trackingMode {
    
    _trackingMode = trackingMode;
    
    switch (self.trackingMode)
    {
        case EnumTrackingPoint:
            [_label setStringValue:@"Point"];
            break;
        case EnumTrackingSelection:
            [_label setStringValue:@"Rect"];
            break;
        default:
            break;
    }    
}

- (void)setCurRect:(NSRect)curRect {
    _curRect = curRect;
    if (self.trackingMode == EnumTrackingSelection)
    {
        [_field setStringValue:[NSString stringWithFormat:@"(%.1f, %.1f, %1.f, %1.f)", 
                                self.curRect.origin.x,
                                self.curRect.origin.y,
                                self.curRect.size.width, 
                                self.curRect.size.height]];
    }
}

- (void)setCurPoint:(NSPoint)curPoint {
    _curPoint = curPoint;
    if (self.trackingMode == EnumTrackingPoint)
    {
        [_field setStringValue:[NSString stringWithFormat:@"(%.1f, %.1f)",
                                self.curPoint.x,
                                self.curPoint.y]];                                
    }
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

            [image release];            
        }
    }
}

- (IBAction)modeGetFrame:(id)sender {
    
}

- (IBAction)zoomIn:(id)sender {
    
    if ([_imageView image])
    {
        _zoomFactor = MIN(kMaxZoomFactor, 2 * _zoomFactor);    
        
        [self zoomView:_imageView withFactor:_zoomFactor];
        
        [_imageView display];
    }
}

- (IBAction)zoomOut:(id)sender {
    
    if ([_imageView image])
    {
        _zoomFactor = MAX(kMinZoomFactor, _zoomFactor / 2.0f);    
        
        [self zoomView:_imageView withFactor:_zoomFactor];
        
        [_imageView display];
    }
}

/////////////////////////////////////////////////////////////////////
//< Events
/////////////////////////////////////////////////////////////////////
- (void)mouseEntered:(NSEvent *)theEvent {
    [[self window] setAcceptsMouseMovedEvents:YES];
    [[NSCursor crosshairCursor] set];
    if (self.trackingMode == EnumTrackingNone)
    {
        self.trackingMode = EnumTrackingPoint;
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    if ([NSCursor currentCursor] == [NSCursor crosshairCursor])
    {
        NSPoint pt = [theEvent locationInWindow];
        NSPoint newPt = [_imageView convertPointFromBase:pt];        
        NSLog(@"mouseDown %f %f", newPt.x, newPt.y);
        _startBasePt = newPt;
        _acceptSelection = YES;        

        self.trackingMode = EnumTrackingSelection;

        NSPoint finalPt = [_imageView pointFromBasePoint:newPt];
        
        self.curRect = NSMakeRect(finalPt.x, finalPt.y, 0, 0);
    }
    else
    {
        _acceptSelection = NO;
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    _acceptSelection = NO;
    self.trackingMode = EnumTrackingNone;
}

- (void)mouseMoved:(NSEvent *)theEvent {
    if (self.trackingMode == EnumTrackingPoint)
    {
        NSPoint pt = [theEvent locationInWindow];
        NSPoint newPt = [_imageView convertPointFromBase:pt];
        NSPoint finalPt = [_imageView pointFromBasePoint:newPt];
        self.curPoint = finalPt;
    }
}

- (void)mouseDragged:(NSEvent *)theEvent {
    if ((self.trackingMode == EnumTrackingSelection) && _acceptSelection)
    {
        NSPoint pt = [theEvent locationInWindow];
        NSPoint newPt = [_imageView convertPointFromBase:pt];        

        //< Find the bottom-left corner point
        NSPoint blPt = NSMakePoint(MIN(_startBasePt.x, newPt.x), MIN(_startBasePt.y, newPt.y));
        //< Find the top-right corner point
        NSPoint trPt = NSMakePoint(MAX(_startBasePt.x, newPt.x), MAX(_startBasePt.y, newPt.y));
        [_selectionView setFrame:NSMakeRect(blPt.x, blPt.y, trPt.x - blPt.x, trPt.y - blPt.y)];
        [_selectionView setHidden:NO];        
        
        [self selectionMoved];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    [[self window] setAcceptsMouseMovedEvents:NO];
    [[NSCursor arrowCursor] set];
    if (self.trackingMode == EnumTrackingPoint)
    {
        self.trackingMode = EnumTrackingNone;
    }
}

@end

@implementation GetFrameWinController (Private) 

- (void)selectionMoved {
    NSPoint blPt = [_imageView pointFromBasePoint:NSMakePoint(NSMinX([_selectionView frame]), NSMinY([_selectionView frame]))];
    NSPoint trPt = [_imageView pointFromBasePoint:NSMakePoint(NSMaxX([_selectionView frame]), NSMaxY([_selectionView frame]))];
    self.curRect = NSMakeRect(blPt.x, trPt.y, trPt.x - blPt.x, blPt.y - trPt.y);
}

- (void)rectRenderFinishedInView:(GetFrameImageView *)view {
    [self updateTrackingArea];
}

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
