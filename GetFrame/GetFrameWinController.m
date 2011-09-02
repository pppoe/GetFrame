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

#define kOutPutFormatCGRect @"CGRectMake(%3.1f, %3.1f, %3.0f, %3.0f)"
#define kOutPutFormatNSRect @"NSMakeRect(%3.1f, %3.1f, %3.0f, %3.0f)"
#define kOutPutFormatPlainRect @"(%3.1f, %3.1f, %3.0f, %3.0f)"

/////////////////////////////////////////////////////////////////////
//< Constants
/////////////////////////////////////////////////////////////////////
#define kMinWinWidth (400)
#define kMinWinHeight (400)

@interface GetFrameWinController (Private) <GetFrameImageViewDelegate>

- (void)updateFieldContent;
- (void)selectionMoved;

@end

@implementation GetFrameWinController
@synthesize curRect = _curRect;
@synthesize outputFormat = _outputFormat;

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
     
    [_scrollView setDocumentView:_imageView];
    
    [_imageView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin];    
    _imageView.delegate = self;    
    
    _selectionView = [[GetFrameSelectionView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];    
    [_selectionView setDragReleaseTarget:self andSelector:@selector(selectionMoved)];
    [_selectionView setDragMovedTarget:self andSelector:@selector(selectionMoved)];
    [_imageView addSubview:_selectionView];
    [_selectionView setHidden:YES];
    
    [_imageView setAcceptsTouchEvents:NO];
    
    self.outputFormat = kOutPutFormatPlainRect;
    _isSelecting = NO;
}

- (void)setCurRect:(NSRect)curRect {
    _curRect = curRect;
    [self updateFieldContent];
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
            
            _acceptSelection = YES;

            [image release];            
        }
    }
}

- (IBAction)switchOutputFormat:(id)sender {
    _mode = (_mode + 1) % OutputFormatModeCount;
    switch (_mode)
    {
        case OutputFormatModePlainRect:
            [_label setStringValue:@"Rect"];
            self.outputFormat = kOutPutFormatPlainRect;
            break;
        case OutputFormatModeCGRect:
            [_label setStringValue:@"CGRect"];
            self.outputFormat = kOutPutFormatCGRect;
            break;
        case OutputFormatModeNSRect:
            [_label setStringValue:@"NSRect"];
            self.outputFormat = kOutPutFormatNSRect;
            break;
        default:
            break;
    }
    [self updateFieldContent];
}

/////////////////////////////////////////////////////////////////////
//< Events
/////////////////////////////////////////////////////////////////////
- (void)mouseEntered:(NSEvent *)theEvent {
    [[self window] setAcceptsMouseMovedEvents:YES];
    [[NSCursor crosshairCursor] set];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (!_acceptSelection)
    {
        return;
    }
    NSPoint pt = [theEvent locationInWindow];
    NSPoint newPt = [_imageView convertPointFromBase:pt];            
    _startBasePt = newPt;
    if (!NSPointInRect(newPt, [_selectionView frame]))
    {
        [_selectionView setHidden:YES];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent {
    if (!_acceptSelection)
    {
        return;
    }
    NSPoint pt = [theEvent locationInWindow];
    NSPoint newPt = [_imageView convertPointFromBase:pt];            
    if (!_isSelecting && ![_selectionView isHidden] && NSPointInRect(newPt, [_selectionView frame]))
    {
        //< Drag the selection, Handled by the Selection View
    }
    else
    {
        //< Find the bottom-left corner point
        NSPoint blPt = NSMakePoint(MIN(_startBasePt.x, newPt.x), MIN(_startBasePt.y, newPt.y));
        //< Find the top-right corner point
        NSPoint trPt = NSMakePoint(MAX(_startBasePt.x, newPt.x), MAX(_startBasePt.y, newPt.y));
        [_selectionView setFrame:NSMakeRect(blPt.x, blPt.y, trPt.x - blPt.x, trPt.y - blPt.y)];
        [_selectionView setHidden:NO];        
        _isSelecting = YES;
    }
    
    [self selectionMoved];
    [self updateFieldContent];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _isSelecting = NO;
}

- (void)mouseExited:(NSEvent *)theEvent {
    [[self window] setAcceptsMouseMovedEvents:NO];
    [[NSCursor arrowCursor] set];
}

- (void)selectionMoved {
    [self updateFieldContent];
}

@end

@implementation GetFrameWinController (Private) 

- (void)updateFieldContent {
    [_field setStringValue:[NSString stringWithFormat:self.outputFormat, 
                            self.curRect.origin.x,
                            self.curRect.origin.y,
                            self.curRect.size.width, 
                            self.curRect.size.height]];
}

- (void)selectionMoved {
    NSPoint blPt = [_imageView pointFromBasePoint:NSMakePoint(NSMinX([_selectionView frame]), NSMinY([_selectionView frame]))];
    NSPoint trPt = [_imageView pointFromBasePoint:NSMakePoint(NSMaxX([_selectionView frame]), NSMaxY([_selectionView frame]))];
    self.curRect = NSMakeRect(blPt.x, trPt.y, trPt.x - blPt.x, blPt.y - trPt.y);
}

- (void)updateTrackingAreas {
    [_imageView removeTrackingRect:_curTrackingArea];
    _curTrackingArea = [_imageView addTrackingRect:[_imageView imageRect]
                                             owner:self
                                          userData:nil
                                      assumeInside:YES];
    [_imageView setAcceptsTouchEvents:YES];
}

@end
