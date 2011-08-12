//
//  GetFrameImageView.h
//  GetFrame
//
//  Created by haoxiang on 8/10/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetFrameImageViewDelegate;

@interface GetFrameImageView : NSView {
@private
    NSImage *_image;
    
    NSRect _imageRect;
    
    NSPoint _originPoint;
    
    id<GetFrameImageViewDelegate> _delegate;
}

@property (nonatomic, assign) NSPoint originPoint;
@property (nonatomic, readonly) NSRect imageRect;
@property (nonatomic, retain) NSImage *image;
@property (nonatomic, assign) id<GetFrameImageViewDelegate> delegate;

- (NSPoint)pointFromBasePoint:(NSPoint)basePoint;

@end
