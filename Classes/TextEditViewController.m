//
//  TextEditViewController.m
//  Do It
//
//  Created by Vytautas on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextEditViewController.h"
#import "AddNewViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextEditViewController

@synthesize parent, currentField, myTableView, insertTextView, insertNumbersView, moreTypicalController, textView, numbersField, otherFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [parent release];
    [currentField release];
    [myTableView release];
    [insertNumbersView release];
    [insertTextView release];
    [moreTypicalController release];
    [textView release];
    [numbersField release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.insertTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.insertNumbersView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    // Adding the "OK" button
    UIImage *myImage = [UIImage imageNamed:@"ok.png"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:myImage forState:UIControlStateNormal];
    myButton.frame = CGRectMake(0.0, 0.0, myImage.size.width, myImage.size.height);
    [myButton addTarget:self action:@selector(addEntry) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    
    [rightButton release];
    [myButton release];
    
    // Adding the "Back" button
    UIButton *myButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
	myButton2.frame = CGRectMake(20, 20, 55, 30); // position in the parent view and set the size of the button
	[myButton2 setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[myButton2 addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:myButton2];
	self.navigationItem.leftBarButtonItem = backButton;
	self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *fieldName = [self.currentField objectForKey:@"field_name"];
    if (self.otherFlag == YES)
    {
        self.myTableView.alpha = 0.0;
        self.insertNumbersView.alpha = 1.0;
        self.insertTextView.alpha = 0.0;
        
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        
        if ([self.parent.collectedData objectForKey:fieldName])
            self.numbersField.text = [self.parent.collectedData objectForKey:fieldName];
        
        [self.numbersField becomeFirstResponder];
        
        return;
    }
    if ([[self.currentField objectForKey:@"type"] isEqualToString:@"number"] || [[self.currentField objectForKey:@"type"] isEqualToString:@"integer"] || [[currentField objectForKey:@"type"] isEqualToString:@"float"]) 
    {
        if (![self.currentField objectForKey:@"allowed_values"] && ![self.currentField objectForKey:@"typical_values"])
        {
            self.myTableView.alpha = 0.0;
            self.insertNumbersView.alpha = 1.0;
            self.insertTextView.alpha = 0.0;
            
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
            
            if ([self.parent.collectedData objectForKey:fieldName])
                self.numbersField.text = [self.parent.collectedData objectForKey:fieldName];
            
            [self.numbersField becomeFirstResponder];
        }
        if ([self.currentField objectForKey:@"allowed_values"])
        {
            self.myTableView.alpha = 1.0;
            self.insertNumbersView.alpha = 0.0;
            self.insertTextView.alpha = 0.0;
            
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }
        if ([self.currentField objectForKey:@"typical_values"])
        {
            self.myTableView.alpha = 1.0;
            self.insertNumbersView.alpha = 0.0;
            self.insertTextView.alpha = 0.0;
            
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }
    }
    if ([[self.currentField objectForKey:@"type"] isEqualToString:@"text"]) 
    {
        if ([self.currentField objectForKey:@"allowed_values"])
        {
            self.myTableView.alpha = 1.0;
            self.insertNumbersView.alpha = 0.0;
            self.insertTextView.alpha = 0.0;
            
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }
        else
        {
            self.myTableView.alpha = 0.0;
            self.insertNumbersView.alpha = 0.0;
            self.insertTextView.alpha = 1.0;
            
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
            
            if ([self.parent.collectedData objectForKey:fieldName])
                self.textView.text = [self.parent.collectedData objectForKey:fieldName];
            
            [self.textView becomeFirstResponder];
        }
    }
    self.navigationItem.hidesBackButton = YES;
    [self.myTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.textView.text = @"";
    self.numbersField.text = @"";
    if (self.otherFlag == YES && self.insertNumbersView.alpha == 1.0) 
    {
        self.otherFlag = NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    self.parent = nil;
//    self.currentField = nil;
//    self.myTableView = nil;
//    self.insertTextView = nil;
//    self.insertNumbersView = nil;
//    self.moreTypicalController = nil;
//    self.textView = nil;
//    self.numbersField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - My Methods

- (void)addEntry
{
    NSString *enteredValue;
    if ([[self.currentField objectForKey:@"type"] isEqualToString:@"number"] || [[self.currentField objectForKey:@"type"] isEqualToString:@"integer"] || [[currentField objectForKey:@"type"] isEqualToString:@"float"]) 
    {
        NSInteger minValue = [[self.currentField objectForKey:@"min"] intValue];
        NSInteger maxValue = [[self.currentField objectForKey:@"max"] intValue];
        enteredValue = [self.numbersField text];
        
        if ([enteredValue intValue] > maxValue || [enteredValue intValue] < minValue) 
        {
            NSString *alertMessage = [NSString stringWithFormat:@"The entered value must be between %d and %d", minValue, maxValue];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                            message:alertMessage 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            return;
        }
    }
    
    if ([[self.currentField objectForKey:@"type"] isEqualToString:@"text"]) 
    {
        enteredValue = [self.textView text];
    }
    
    NSString *fieldName = [self.currentField objectForKey:@"field_name"];
    [self.parent.collectedData setObject:enteredValue forKey:fieldName];
    NSLog(@"%@", self.parent.collectedData);
    
    if (self.otherFlag == YES) 
    {
        self.otherFlag = NO;
        NSMutableArray *allControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        [allControllers removeObjectAtIndex:[allControllers count] - 2];
        [self.navigationController setViewControllers:allControllers animated:NO];
        [allControllers release];
    }
    
    [self backButtonPressed];
}

- (void)backButtonPressed 
{
    [self.textView resignFirstResponder];
    [self.numbersField resignFirstResponder];
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView data source and delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    NSInteger index = [indexPath row];
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) 
    {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.opaque = NO;
	}
    
    if (self.myTableView.alpha == 1.0) 
    {
        if ([self.currentField objectForKey:@"allowed_values"])
        {
            cell.textLabel.text = [[[self.currentField objectForKey:@"allowed_values"] objectAtIndex:index] objectAtIndex:1];
            
            NSString *fieldName = [self.currentField objectForKey:@"field_name"];
            NSString *currentValue = [self.parent.collectedData objectForKey:fieldName];
            NSString *cellValue = [[[self.currentField objectForKey:@"allowed_values"] objectAtIndex:index] objectAtIndex:0];
            if (currentValue == cellValue)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if ([self.currentField objectForKey:@"typical_values"]) 
        {
            if (index == [[self.currentField objectForKey:@"typical_values"] count])
                cell.textLabel.text = [NSString stringWithFormat:@"Other..."];
            else
            {
                cell.textLabel.text = [[[self.currentField objectForKey:@"typical_values"] objectAtIndex:index] objectAtIndex:1];
            
                NSString *fieldName = [self.currentField objectForKey:@"field_name"];
                NSString *currentValue = [self.parent.collectedData objectForKey:fieldName];
                NSString *cellValue = [[[self.currentField objectForKey:@"typical_values"] objectAtIndex:index] objectAtIndex:0];
                if (currentValue == cellValue)
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                else
                    cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }  
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath 
{
    NSInteger index = [indexPath row];
    
    if ([self.currentField objectForKey:@"typical_values"])
    {
        if ([indexPath row] == [[self.currentField objectForKey:@"typical_values"] count]) 
        {
            if (self.moreTypicalController == nil) 
            {
                self.moreTypicalController = [[TextEditViewController alloc] init];
                self.moreTypicalController.parent = self.parent;
                self.moreTypicalController.currentField = self.currentField;
            }
            self.moreTypicalController.otherFlag = YES;
            
            [self.navigationController pushViewController:self.moreTypicalController animated:YES];
        }
        else
        {
            NSString *fieldName = [self.currentField objectForKey:@"field_name"];
            NSString *cellValue = [[[self.currentField objectForKey:@"typical_values"] objectAtIndex:index] objectAtIndex:0];
            [self.parent.collectedData setObject:cellValue forKey:fieldName];
            [tableView reloadData];
            NSLog(@"%@", self.parent.collectedData);
        }
    }
    if ([self.currentField objectForKey:@"allowed_values"]) 
    {
        NSString *fieldName = [self.currentField objectForKey:@"field_name"];
        NSString *cellValue = [[[self.currentField objectForKey:@"allowed_values"] objectAtIndex:index] objectAtIndex:0];
        [self.parent.collectedData setObject:cellValue forKey:fieldName];
        [tableView reloadData];
        NSLog(@"%@", self.parent.collectedData);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (self.myTableView.alpha == 1.0) 
    {
        if ([self.currentField objectForKey:@"allowed_values"])
        {
            return [[self.currentField objectForKey:@"allowed_values"] count];
        }
        if ([self.currentField objectForKey:@"typical_values"]) 
        {
            return [[self.currentField objectForKey:@"typical_values"] count] + 1;
        }
    }   
    return 0;
}

#pragma - UITextView delegate methods

- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) 
    {
        [aTextView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
