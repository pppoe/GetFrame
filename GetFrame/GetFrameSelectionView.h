//
//  GetFrameSelectionView.h
//  GetFrame
//
//  Created by haoxiang on 8/12/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GetFrameSelectionView : NSBox {
@private
    id targetRelease;
    SEL selectorRelease;

    id targetMoved;
    SEL selectorMoved;

    //< When User's Mouse located in this area, it is able to resize the current View
    NSTrackingArea *resizeArea;
}

- (void)setDragReleaseTarget:(id)theTarget andSelector:(SEL)theSelector;
- (void)setDragMovedTarget:(id)theTarget andSelector:(SEL)theSelector;

@end
