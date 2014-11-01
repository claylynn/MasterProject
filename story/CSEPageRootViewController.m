//
//  CSEPageRootViewController.m
//  story
//
//  Created by Chen on 10/26/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import "CSEPageRootViewController.h"

@interface CSEPageRootViewController ()
{
    NSUInteger currentIndex;
    NSUInteger preIndex;
}
@property (strong,nonatomic) NSString *dataFilePath;
@property (strong, nonatomic) NSMutableArray *pageData;
@property (strong, nonatomic) CSEPageContentViewController *currentPage;
@end

@implementation CSEPageRootViewController
@synthesize pageData;
@synthesize currentPage;
@synthesize dataFilePath;

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
    
    //file processing
    
    NSFileManager *filemgr;
    NSString *docsDir;
    NSArray *dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    self.dataFilePath = [[NSString alloc] initWithString:
                         [docsDir stringByAppendingPathComponent:self.fileName]];
    if([filemgr fileExistsAtPath:self.dataFilePath])
    {
        NSLog(@"exist");
        self.pageData = [NSKeyedUnarchiver unarchiveObjectWithFile:self.dataFilePath];
    }
    else
    {
        self.pageData = [NSMutableArray arrayWithCapacity:10];
    }
    
    //[self.pageData addObject:[UIImage imageNamed:@"leaves.gif"]];
    
    //Create pre,next buttons
    
    UIBarButtonItem *preButton = [[UIBarButtonItem alloc]initWithTitle:@"Pre" style:UIBarButtonItemStylePlain target:self action:@selector(preButtonPressed:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonPressed:)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveDataToFile:)];
    //self.navigationItem.leftBarButtonItem = preButton;
    self.navigationItem.rightBarButtonItems = [[NSArray alloc]initWithObjects:nextButton,preButton, nil];
    self.navigationItem.leftItemsSupplementBackButton=YES;
    self.navigationItem.leftBarButtonItem=saveButton;
    
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    //XYZDataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    currentIndex=0;
    CSEPageContentViewController *startingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSEPageContentViewController"];
    startingViewController.delegate=self;
    
    if([self.pageData count]!=0)
        startingViewController.drawedImage = self.pageData[currentIndex];
    self.currentPage=startingViewController;
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    CGRect pageViewRect = self.view.bounds;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    self.pageViewController.view.frame = pageViewRect;
    [self.pageViewController didMoveToParentViewController:self];
    
    
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


#pragma mark - UIPageViewController delegate methods

/*
 - (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
 {
 
 }
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}


-(IBAction)preButtonPressed:(id)sender
{
    //boundary
    if (currentIndex == 0) {
        return ;
    }
    
    //check if need to add an page
    /*
    if(currentIndex==[self.pageData count])
    {
        [self.pageData addObject:self.currentPage.drawedImage];
    }
    else
    {
        self.pageData[currentIndex]=self.currentPage.drawedImage;
    }
    */
    
    //update current page
    preIndex=currentIndex;
    currentIndex--;
    
    
    //prepare data
    CSEPageContentViewController *dataViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSEPageContentViewController"];
    dataViewController.delegate=self;
    if(self.pageData[currentIndex]==nil)
    {
        NSLog(@"!!!nil");
        return;
    }
    dataViewController.drawedImage = self.pageData[currentIndex];
    self.currentPage=dataViewController;
    
    NSArray *viewControllers = @[dataViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

-(IBAction)nextButtonPressed:(id)sender
{
    NSLog(@"next button pressed");
    //boundary
    if (currentIndex == 9) {
        return ;
    }
    //check if need to add an page
    /*
    if(currentIndex==[self.pageData count])
    {
        [self.pageData addObject:self.currentPage.drawedImage];
    }
    else
    {
        self.pageData[currentIndex]=self.currentPage.drawedImage;
    }
     */
    
    //update current page
    preIndex=currentIndex;
    currentIndex++;
    
    //prepare data
    CSEPageContentViewController *dataViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSEPageContentViewController"];
    dataViewController.delegate=self;
    if(currentIndex<[self.pageData count])
        dataViewController.drawedImage = self.pageData[currentIndex];
    self.currentPage=dataViewController;
    
    NSArray *viewControllers = @[dataViewController];

    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

-(IBAction)saveDataToFile:(id)sender
{
    if(currentIndex==[self.pageData count])
    {
        [self.pageData addObject:self.currentPage.drawedImage];
    }
    else
    {
        self.pageData[currentIndex]=self.currentPage.drawedImage;
    }
    [NSKeyedArchiver archiveRootObject:self.pageData toFile:self.dataFilePath];
    NSLog(@"save data to file completed");
    
}


-(void)autoSaveImage:(UIImage *)image
{
    NSLog(@"auto saving image..");
    if(preIndex==[self.pageData count])
    {
        [self.pageData addObject:image];
    }
    else
    {
        self.pageData[preIndex]=image;
    }
}

@end
