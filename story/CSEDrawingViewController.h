//
//  CSEDrawingViewController.h
//  story
//
//  Created by Chen on 10/26/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "CSEDrawingView.h"

@interface CSEDrawingViewController : GLKViewController<Drawing,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
- (IBAction)changeColor:(UISegmentedControl *)sender;
- (IBAction)loadImage:(id)sender;
@property (nonatomic,strong) UIImage *savedImage;
@end
