//
//  CSEDrawingViewController.m
//  story
//
//  Created by Chen on 10/26/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import "CSEDrawingViewController.h"

@interface CSEDrawingViewController ()

@end

@implementation CSEDrawingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeColor:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0)
        [(CSEDrawingView *)self.view changeColorWithRed:0.0f green:0.0f blue:0.0];
    else if(sender.selectedSegmentIndex == 1)
        [(CSEDrawingView *)self.view changeColorWithRed:1.0f green:0.0f blue:0.0f];
    else if (sender.selectedSegmentIndex == 2)
        [(CSEDrawingView *)self.view changeColorWithRed:0.0f green:1.0f blue:0.0f];
    else if (sender.selectedSegmentIndex == 3)
        [(CSEDrawingView *)self.view changeColorWithRed:0.0f green:0.0f blue:1.0f];
    else if (sender.selectedSegmentIndex == 4)
        [(CSEDrawingView *)self.view changeColorWithRed:1.0f green:1.0f blue:1.0f];
    
}

- (IBAction)loadImage:(id)sender {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self;
    [self presentModalViewController:pickerController animated:YES];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    CSEDrawingView *view=(CSEDrawingView *)self.view;
    [view loadView:image];
    [self dismissModalViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"view will disappear");
}
@end
