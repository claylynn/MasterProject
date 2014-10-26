//
//  CSEDrawingView.h
//  story
//
//  Created by Chen on 10/26/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface CSEDrawingView : GLKView

@property(copy, nonatomic) UIImage *savedImage;

-(void)changeColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
- (void)initView:(UIImage *)savedImage;
- (void) loadView:(UIImage *)userImage;

@end
