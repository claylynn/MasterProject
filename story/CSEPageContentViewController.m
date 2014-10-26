//
//  CSEPageContentViewController.m
//  story
//
//  Created by Chen on 10/26/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import "CSEPageContentViewController.h"

@interface CSEPageContentViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation CSEPageContentViewController

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
    self.imageView.image=self.drawedImage;

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

- (IBAction)unwindToMain:(UIStoryboardSegue *)unwindSegue
{
    NSLog(@"unwind method called");
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    self.drawedImage = ((GLKView *)sourceViewController.view).snapshot;
    self.imageView.image= self.drawedImage;
    if(self.drawedImage == nil)
    {
        NSLog(@"received nil snapshot");
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"enter prepareForSegue()");
    if(self.drawedImage)
    {
        NSLog(@"with inital image");
        CSEDrawingViewController* destinationViewController = segue.destinationViewController;
        CSEDrawingView *destinationView = (CSEDrawingView *)destinationViewController.view;
        destinationView.savedImage = self.drawedImage;
        if(!destinationView.savedImage)
            NSLog(@"prepareForSegue:nil destinationView.savedImage");
        //destinationViewController.savedImage=self.drawImage;
        
    }
    else
    {
        NSLog(@"no initial image");
    }
}

- (IBAction)saveImage:(id)sender{
    [self.delegate saveDataToFile];
}



@end
