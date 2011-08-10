//
//  GetFrameWinController.h
//  GetFrame
//
//  Created by hli on 8/9/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GetFrameWinController : NSWindowController {

@private
    IBOutlet NSImageView *_imageView;
    IBOutlet NSScrollView *_scrollView;
    

    //< For Zooming    
    NSSize _orgSize; //< Original Image Size
    float _zoomFactor;
}

- (IBAction)openImage:(id)sender;

- (IBAction)modeGetFrame:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@end
