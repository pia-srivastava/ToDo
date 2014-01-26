//
//  ToDoTableViewController.h
//  ToDo
//
//  Created by Pia Srivastava on 1/22/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoTableViewController : UITableViewController <UITextViewDelegate>
@property NSMutableArray *toDoItems;

-(void)addItem:(NSString *)item;
@property NSString *toDoItem;

@end
