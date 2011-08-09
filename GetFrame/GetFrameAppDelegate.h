//
//  GetFrameAppDelegate.h
//  GetFrame
//
//  Created by hli on 8/9/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GetFrameAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
