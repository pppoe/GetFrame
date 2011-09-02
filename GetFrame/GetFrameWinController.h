//
//  GetFrameWinController.h
//  GetFrame
//
//  Created by haoxiang on 8/9/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GetFrameImageView;
@class GetFrameSelectionView;

typedef enum {
    OutputFormatModePlainRect,
    OutputFormatModeCGRect,
    OutputFormatModeNSRect,
    OutputFormatModeCount
} OutputFormatMode;

@interface GetFrameWinController : NSWindowController {

@private
    IBOutlet GetFrameImageView *_imageView;
    IBOutlet NSScrollView *_scrollView;
    
    IBOutlet NSTextField *_label;
    IBOutlet NSTextField *_field;
    
    GetFrameSelectionView *_selectionView;
        
    NSTrackingRectTag _curTrackingArea;
    
    //< For Dragging and Selection
    NSPoint _startBasePt;
    
    //< Info
    NSRect _curRect;
    
    NSString *_outputFormat;
    
    //< Flag
    BOOL _acceptSelection;
    BOOL _isSelecting;
    OutputFormatMode _mode;
}

- (IBAction)openImage:(id)sender;

- (IBAction)switchOutputFormat:(id)sender;

@property (nonatomic, assign) NSRect curRect;
@property (nonatomic, retain) NSString *outputFormat;

@end
