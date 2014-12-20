//
//  CSETableViewController.h
//  story
//
//  Created by Chen on 10/30/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSEPageRootViewController.h"
@interface CSETableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *booksTableView;
@end
