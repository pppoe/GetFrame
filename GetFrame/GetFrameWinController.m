//
//  GetFrameWinController.m
//  GetFrame
//
//  Created by hli on 8/9/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import "GetFrameWinController.h"


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
        }
    }
}

@end
