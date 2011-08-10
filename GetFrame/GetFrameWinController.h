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
}

- (IBAction)openImage:(id)sender;

@end
