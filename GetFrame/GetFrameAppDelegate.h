//
//  GetFrameAppDelegate.h
//  GetFrame
//
//  Created by haoxiang on 8/9/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GetFrameWinController;

@interface GetFrameAppDelegate : NSObject <NSApplicationDelegate> {
    GetFrameWinController *_winController;
}

@end
