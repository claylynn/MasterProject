//
//  CSEPageContentViewController.h
//  story
//
//  Created by Chen on 10/26/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "CSEDrawingViewController.h"
#import "CSEDrawingView.h"

//define a protocal
@protocol SaveDataDelegate <NSObject>
-(void)saveDataToFile;
@end



@interface CSEPageContentViewController : UIViewController
@property (copy,nonatomic) UIImage *drawedImage;
@property (weak, nonatomic)id<SaveDataDelegate>delegate;
- (IBAction)saveImage:(id)sender;
@end
