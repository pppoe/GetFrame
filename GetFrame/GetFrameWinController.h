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
    EnumTrackingNone,  
    EnumTrackingPoint,  
    EnumTrackingSelection,  
} EnumTrackingMode;

@interface GetFrameWinController : NSWindowController {

@private
    IBOutlet GetFrameImageView *_imageView;
    IBOutlet NSScrollView *_scrollView;
    
    IBOutlet NSTextField *_label;
    IBOutlet NSTextField *_field;
    
    GetFrameSelectionView *_selectionView;
    
    //< For Zooming    
    NSSize _orgSize; //< Original Image Size
    float _zoomFactor;
    
    NSTrackingRectTag _curTrackingArea;
    
    //< For Dragging and Selection
    NSPoint _startBasePt;
    EnumTrackingMode _trackingMode;
    BOOL _acceptSelection;
    
    //< Info
    NSRect _curRect;
    NSPoint _curPoint;
}

- (IBAction)openImage:(id)sender;

- (IBAction)modeGetFrame:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@property (nonatomic, assign) NSRect curRect;
@property (nonatomic, assign) NSPoint curPoint;
@property (nonatomic, assign) EnumTrackingMode trackingMode;

@end
