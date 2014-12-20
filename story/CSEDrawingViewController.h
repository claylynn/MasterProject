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
@property CGFloat colorR;
@property CGFloat colorG;
@property CGFloat colorB;
@property (strong, nonatomic) IBOutlet UILabel *labelR;
@property (strong, nonatomic) IBOutlet UILabel *labelG;
@property (strong, nonatomic) IBOutlet UILabel *labelB;

- (IBAction)colorButtonPressed:(UIButton *)sender;
- (IBAction)widthButtonPressed:(UIButton *)sender;
@end
