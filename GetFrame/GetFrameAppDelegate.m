//
//  GetFrameAppDelegate.m
//  GetFrame
//
//  Created by haoxiang on 8/9/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import "GetFrameAppDelegate.h"
#import "GetFrameWinController.h"

@implementation GetFrameAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _winController = [[GetFrameWinController alloc] init];
    [_winController showWindow:nil];
}

- (void)dealloc {
    [_winController release];
    [super dealloc];
}
    
@end
