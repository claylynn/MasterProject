//
//  CSETableViewController.m
//  story
//
//  Created by Chen on 10/30/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import "CSETableViewController.h"

@interface CSETableViewController ()
@property (nonatomic,strong) NSMutableArray *books;
@property (nonatomic,strong) NSMutableArray *bookNames;
@property (strong,nonatomic) NSString *dataFilePath;
@end

@implementation CSETableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //file processing
    NSFileManager *filemgr;
    NSString *docsDir;
    NSArray *dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    self.dataFilePath = [[NSString alloc] initWithString:
                         [docsDir stringByAppendingPathComponent:@"story02.data"]];
    if([filemgr fileExistsAtPath:self.dataFilePath])
    {
        NSLog(@"table data exist");
        self.books = [NSKeyedUnarchiver unarchiveObjectWithFile:self.dataFilePath];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.title=@"Library";
    self.booksTableView.delegate=self;
    self.booksTableView.dataSource=self;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.booksTableView setEditing:editing animated:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.books count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"appcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSLog(@"name of the book %@",[self.bookNames objectAtIndex:indexPath.row]);
    cell.textLabel.text=[[NSString alloc]initWithFormat:@"%@",
                         [self.bookNames objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text=@"detail";
    
    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //NSMutableArray *deletedBook = [self.books objectAtIndex:indexPath.row];
        [self.books removeObjectAtIndex:indexPath.row];
        [self.bookNames removeObjectAtIndex:indexPath.row];
        [self.booksTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        

        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//add a book
- (void)insertNewObject:(id)sender
{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Add A Book"
                                                message:@"Enter the name of your book"
                                                delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //get input from the alert
        UITextField *name = [alertView textFieldAtIndex:0];
        NSLog(@"username: %@", name.text);
        //save the name
        if(!self.bookNames){
            self.bookNames=[[NSMutableArray alloc] init];
        }
        [self.bookNames addObject:name.text];
        //add a book object
        if (!self.books) {
            self.books = [[NSMutableArray alloc] init];
        }
        [self.books addObject:[[NSMutableArray alloc]init]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.books count]-1 inSection:0];
        [self.booksTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //prepare pageData,books[i]
    CSEPageRootViewController *destinationViewController=segue.destinationViewController;
    UITableViewCell *cell= sender;
    NSIndexPath *index=[self.booksTableView indexPathForCell:cell];
    destinationViewController.fileName = [[NSString alloc]initWithFormat:@"book_%d.data",index.row];
    NSLog(@"%@",[[NSString alloc]initWithFormat:@"book_%d.data",index.row]);
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSKeyedArchiver archiveRootObject:self.books toFile:self.dataFilePath];
    NSLog(@"save data to file completed");
    NSLog(@"table view will disappear");
}

-(void)saveDataToFile
{
    [NSKeyedArchiver archiveRootObject:self.books toFile:self.dataFilePath];

}

@end
