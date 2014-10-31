//
//  CSEPageRootViewController.h
//  story
//
//  Created by Chen on 10/26/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSEPageContentViewController.h"
@interface CSEPageRootViewController : UIViewController<UIPageViewControllerDelegate,SaveDataDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong,nonatomic) NSString *dataFilePath;
@property (strong ,nonatomic) NSString *fileName;
@end
