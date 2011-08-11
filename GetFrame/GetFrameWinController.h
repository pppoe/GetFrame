//
//  GetFrameWinController.h
//  GetFrame
//
//  Created by haoxiang on 8/9/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GetFrameImageView;

@interface GetFrameWinController : NSWindowController {

@private
    IBOutlet GetFrameImageView *_imageView;
    IBOutlet NSScrollView *_scrollView;
    
    IBOutlet NSTextField *_label;
    IBOutlet NSTextField *_field;
    
    //< For Zooming    
    NSSize _orgSize; //< Original Image Size
    float _zoomFactor;
    
    NSTrackingRectTag _curTrackingArea;
}

- (IBAction)openImage:(id)sender;

- (IBAction)modeGetFrame:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@end
