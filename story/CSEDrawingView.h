//
//  CSEDrawingView.h
//  story
//
//  Created by Chen on 10/26/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import <GLKit/GLKit.h>


@protocol Drawing <NSObject>
- (void)drawing:(CGPoint)start toPoint:(CGPoint)end;
- (void)clear;
@end

@interface CSEDrawingView : GLKView
@property (weak, nonatomic)id<Drawing> drawingDelegate;
@property Boolean needErase;

@end
