//
//  TextEditViewController.h
//  Do It
//
//  Created by Vytautas on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddNewViewController;

@interface TextEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    AddNewViewController *parent;
    NSDictionary *currentField;
    IBOutlet UITableView *myTableView;
    IBOutlet UIView *insertNumbersView;
    IBOutlet UIView *insertTextView;
    TextEditViewController *moreTypicalController;
    IBOutlet UITextView *textView;
    IBOutlet UITextField *numbersField;
    BOOL otherFlag;
}

@property (nonatomic, retain) AddNewViewController *parent;
@property (nonatomic, retain) NSDictionary *currentField;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIView *insertNumbersView;
@property (nonatomic, retain) IBOutlet UIView *insertTextView;
@property (nonatomic, retain) TextEditViewController *moreTypicalController;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UITextField *numbersField;
@property BOOL otherFlag;

- (void)addEntry;
- (void)backButtonPressed;

@end
