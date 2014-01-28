//
//  ToDoTableViewController.m
//  ToDo
//
//  Created by Anish Srivastava on 1/22/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

#import "ToDoTableViewController.h"
#import "EditableCell.h"
#import <Parse/Parse.h>

@interface ToDoTableViewController ()
@property (weak, nonatomic) IBOutlet EditableCell *editableCell;
@property NSInteger rowSelected;
@end

@implementation ToDoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initialize the array and defaults
    self.toDoItems = [[NSMutableArray alloc]init];
    
    self.title = @"To Do List";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    UINib *editableNib = [UINib nibWithNibName:@"EditableCell" bundle:nil];
    [self.tableView registerNib:editableNib forCellReuseIdentifier:@"EditableCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [self loadInitialData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.toDoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath!!!");
    static NSString *CellIdentifier = @"EditableCell";
    EditableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    // Configure the cell...
    NSString *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.toDoItem.text = toDoItem;
    cell.toDoItem.tag = indexPath.row;
    
    [cell.toDoItem becomeFirstResponder];
    cell.toDoItem.delegate = self;
    self.rowSelected = indexPath.row;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma custom methods
- (void)loadInitialData {
    
    //Parse retrieval
    //    PFQuery *query = [PFQuery queryWithClassName:@"ToDo"];
    //    [query getObjectInBackgroundWithId:@"pdmXGFp6Gj" block:^(PFObject *retrievedItems, NSError *error) {
    //        NSLog(@"The stuff retrieved is %@", retrievedItems);
    //        NSString *item = retrievedItems[@"toDoItemValue"];
    //        NSLog(@"item is %@",item);
    //       [self.toDoItems addObject:item];
    //
    //    }];
    
    //Retrieve data from NSUserDefaults
    NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"toDoItems"];
    
    if(tempArray != nil){
        NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"toDoItems"]];
        self.toDoItems = array;
    }
    
    [self.tableView reloadData];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	
//	NSString *myString = [self.toDoItems objectAtIndex:indexPath.row];
//	
//	UITextView *textView = [[UITextView alloc] init];
//	[textView setAttributedText:[[NSAttributedString alloc] initWithString:myString]];
//	
//	CGRect screenRect = [[UIScreen mainScreen] bounds];
//	//CGFloat width = [self isPortraitOrientation] ? screenRect.size.width : screenRect.size.height;
//	CGFloat width = screenRect.size.width;
//	width -= 64;
//	
//	CGRect textRect = [textView.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
//												  options:NSStringDrawingUsesLineFragmentOrigin
//											   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
//												  context:nil];
//	
//	return textRect.size.height + 20;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"heightForRowAtIndexPath!!!!");
    
    UITextView *textView = [[UITextView alloc] init];
    NSString *theText = [self.toDoItems objectAtIndex:indexPath.row];
    [textView setAttributedText:[[NSAttributedString alloc] initWithString:theText]];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat width = screenRect.size.width;
    width -= 64;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:14];
//    CGRect textRect = [theText boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font}context:nil];
    
    CGRect textRect = [textView.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}context:nil];
    
    CGFloat h = textRect.size.height + 30;
    
    NSLog(@"returning %f", h);
    return h;
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	
    //NSLog(@"In textFieldShouldBeginEditing");
	
	return YES;
}

-(void)addItem:(NSString *)item{
    
    [self.toDoItems addObject:@""];
    
    //    PFObject *testObject = [PFObject objectWithClassName:@"ToDo"];
    //    testObject[@"foo"] = @"In ToDoViewController, addItem(), Pia";
    //    testObject[@"toDoItemValue"] = @"abc";
    //    [testObject saveInBackground];
    //
    
    [self.tableView reloadData];
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.toDoItems removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.toDoItems forKey:@"toDoItems"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
    
}


//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//	NSLog(@"In shouldChangeTextInRange");
//    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
//    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
//    NSUInteger location = replacementTextRange.location;
//    if (location != NSNotFound){
//		
//		[self.toDoItems replaceObjectAtIndex:textView.tag withObject:textView.text];
//		[[NSUserDefaults standardUserDefaults] setObject:self.toDoItems forKey:@"toDoItems"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//		[textView resignFirstResponder];
//		
//		[self.tableView reloadData];
//		
//		return YES;
//    } else {
//		[self.toDoItems replaceObjectAtIndex:textView.tag withObject:textView.text];
//		[[NSUserDefaults standardUserDefaults] setObject:self.toDoItems forKey:@"toDoItems"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//		[self.tableView beginUpdates];
//		[self.tableView endUpdates];
//        
//	}
//	
//	
//    return YES;
//}

//Method I get called back whenever soemthing is about to be edited
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *text1 = [textView.text stringByReplacingCharactersInRange:range withString:text];
    //this is where i would put in validation if I wouldn't want the user to type in certain things
    
   	[self.toDoItems replaceObjectAtIndex:textView.tag withObject:text1];
    [[NSUserDefaults standardUserDefaults] setObject:self.toDoItems forKey:@"toDoItems"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [self.tableView reloadData];

    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
