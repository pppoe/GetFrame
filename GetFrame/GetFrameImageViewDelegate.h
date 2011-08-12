//
//  GetFrameImageViewDelegate.h
//  GetFrame
//
//  Created by haoxiang on 8/12/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GetFrameImageView;

@protocol GetFrameImageViewDelegate <NSObject>

@optional
- (void)rectRenderFinishedInView:(GetFrameImageView *)view;

@end
