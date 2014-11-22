//
//  CSEPageContentViewController.m
//  story
//
//  Created by Chen on 10/26/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import "CSEPageContentViewController.h"

@interface CSEPageContentViewController ()
{
    //control the behavior of viewWillDisapper()
    //there are only two cases that this view will disapper
    //1.user will draw something: needSave=false. viewWillDisapper() does nothing
    //2.user will go to another page: needSave=true. viewWillDisapper() saves self.drawedImage
    Boolean needSave;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *textView;

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
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"page content view will appear:%@",self.typedText);
    //the pagecontent view controller will always displays a image if it has.
    self.imageView.image=self.drawedImage;
    self.textView.text=self.typedText;
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"page content view will disappear;text:%@",self.textView.text);
    if(needSave)
    {
        [self.delegate autoSaveImage:self.drawedImage];
        [self.delegate autoSaveText1:self.textView.text];
    }
    else
        [self.delegate autoSaveText2:self.textView.text];
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
    NSLog(@"unwindToMain()");
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    //take a snapshot of what the user has drawn
    self.drawedImage = ((GLKView *)sourceViewController.view).snapshot;
    
    needSave=true;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue()");
    needSave=false;
    self.typedText=self.textView.text;
    if(self.drawedImage)
    {
        NSLog(@"with inital image");
        CSEDrawingViewController* destinationViewController = segue.destinationViewController;
        /*
        CSEDrawingView *destinationView = (CSEDrawingView *)destinationViewController.view;
        destinationView.savedImage = self.drawedImage;
         */
        destinationViewController.savedImage=self.drawedImage;
    }
    else
    {
        NSLog(@"without initial image");
    }
}

/*
- (IBAction)saveImage:(id)sender{
    [self.delegate saveDataToFile];
}
*/


@end
