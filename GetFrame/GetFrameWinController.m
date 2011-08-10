//
//  GetFrameWinController.m
//  GetFrame
//
//  Created by hli on 8/9/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import "GetFrameWinController.h"

/////////////////////////////////////////////////////////////////////
//< Constants
/////////////////////////////////////////////////////////////////////
#define kMinWinWidth (400)
#define kMinWinHeight (400)

#define kMaxWinWidth (800)
#define kMaxWinHeight (800)

#define kImagePadding (5)

#define kMaxImageWidth (5000)
#define kMaxImageHeight (5000)

#define kMinImageWidth (16)
#define kMinImageHeight (16)

#define kMinZoomFactor (1.0f)
#define kMaxZoomFactor (8.0f)

@interface GetFrameWinController (Private)

- (void)adjustFrameForNewImage;
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
            [image release];
            
            [self adjustFrameForNewImage];
        }
    }
}

- (IBAction)modeGetFrame:(id)sender {
    
}

- (IBAction)zoomIn:(id)sender {
    
    _zoomFactor = MIN(kMaxZoomFactor, 2 * _zoomFactor);    
    
    [self zoomView:_imageView withFactor:_zoomFactor];
}

- (IBAction)zoomOut:(id)sender {
    
    _zoomFactor = MAX(kMinZoomFactor, _zoomFactor / 2.0f);    
    
    [self zoomView:_imageView withFactor:_zoomFactor];
}

@end

@implementation GetFrameWinController (Private)

- (void)zoomView:(NSView *)view withFactor:(float)factor {
    NSSize s = [view frame].size;
    NSPoint org = [view frame].origin;
    NSPoint ctrPt = NSMakePoint(org.x + s.width/2.0f, org.y + s.height/2.0f);
    NSSize newSize = NSMakeSize(_orgSize.width * factor, _orgSize.height * factor);
    [[view animator] setFrame:NSMakeRect(ctrPt.x - newSize.width/2.0f, 
                                         ctrPt.y - newSize.height/2.0f,
                                         newSize.width, newSize.height)];
}

- (void)adjustFrameForNewImage 
{
    
//    NSSize size = [[_imageView image] size];
//    
//    //< Keep the Left and Bottom Padding
//    float leftPadding = _imageView.frame.origin.x;
//    float bottomPadding = _imageView.frame.origin.y;
//    
//    //< Keep the Center Point
//    NSSize winSize = NSMakeSize(MIN(MAX((size.width + 2 * kImagePadding + 2 * leftPadding), kMinWinWidth), kMaxWinWidth),
//                                MIN(MAX((size.height + 2 * kImagePadding + 2 * bottomPadding), kMinWinHeight), kMaxWinHeight));
//    NSRect oldWinFrame = [[self window] frame];
//    NSPoint ctrPoint = NSMakePoint(oldWinFrame.origin.x + oldWinFrame.size.width/2.0f,
//                                   oldWinFrame.origin.y + oldWinFrame.size.height/2.0f);
//
//    NSRect winFrame = NSMakeRect(ctrPoint.x - winSize.width/2.0f, 
//                                 ctrPoint.y - winSize.height/2.0f, 
//                                 winSize.width, winSize.height);
//    [[self window] setFrame:winFrame
//                    display:NO
//                    animate:YES];
//    
//    NSRect rect = NSMakeRect((winSize.width - (size.width + 2*kImagePadding))/2.0f, 
//                             (winSize.height - (size.height + 2*kImagePadding))/2.0f, 
//                             (size.width + 2*kImagePadding), 
//                             (size.height + 2*kImagePadding));
//    [_imageView setFrame:rect];    
//    
//    [[self window] setMinSize:NSMakeSize(winFrame.size.width, winFrame.size.height)];
    
}

@end
