//
//  CSEDrawingView.m
//  story
//
//  Created by Chen on 10/26/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import "CSEDrawingView.h"
@interface CSEDrawingView()
{
    Boolean firstTouch;
}
@property(nonatomic, readwrite) CGPoint location;
@property(nonatomic, readwrite) CGPoint previousLocation;
@end




@implementation CSEDrawingView
@synthesize location;
@synthesize previousLocation;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        
    }
    return self;
}


-(void)drawRect:(CGRect)rect
{
    if(!self.needErase)
    {
        [self.drawingDelegate clear];
        self.needErase=true;
    }
    else
    {
        CGPoint p;
        p.x=0.0f;
        p.y=0.0f;
        [self.drawingDelegate drawing:p toPoint:p];
    }
}



- (void)renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end
{
    [self.drawingDelegate drawing:start toPoint:end];
}



//TOUCH
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
	CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	firstTouch = YES;
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
	location = [touch locationInView:self];
	location.y = bounds.size.height - location.y;
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect				bounds = [self bounds];
	UITouch*			touch = [[event touchesForView:self] anyObject];
    
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
		previousLocation.y = bounds.size.height - previousLocation.y;
	} else {
		location = [touch locationInView:self];
	    location.y = bounds.size.height - location.y;
		previousLocation = [touch previousLocationInView:self];
		previousLocation.y = bounds.size.height - previousLocation.y;
	}
    
	// Render the stroke
	[self renderLineFromPoint:previousLocation toPoint:location];
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
		previousLocation.y = bounds.size.height - previousLocation.y;
		[self renderLineFromPoint:previousLocation toPoint:location];
	}
}



@end
