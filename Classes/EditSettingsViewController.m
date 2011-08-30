//
//  EditSettingsViewController.m
//  Do It
//
//  Created by Vytautas on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditSettingsViewController.h"
#import "Do_ItViewController.h"


@implementation EditSettingsViewController

@synthesize pickerView, myTableView, myPickerView, parent, showView, pickerNumbers;

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
    [pickerView release];
    [myTableView release];
    [myPickerView release];
    [parent release];
    [showView release];
    [pickerNumbers release];
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
    
    self.pickerNumbers = [[NSMutableArray alloc] init];
    int number = 10;
    for (int i = 0; i < 10; i++)
    {
        NSString *entry = [NSString stringWithFormat:@"%d", number];
        [self.pickerNumbers addObject:entry];
        number = number + 10;
    }
    
    self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.myPickerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    // Adding the "OK" button
    UIImage *myImage = [UIImage imageNamed:@"ok.png"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:myImage forState:UIControlStateNormal];
    myButton.frame = CGRectMake(0.0, 0.0, myImage.size.width, myImage.size.height);
    [myButton addTarget:self action:@selector(setSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // Adding the "Back" button
    UIButton *myButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
	myButton2.frame = CGRectMake(20, 20, 55, 30); // position in the parent view and set the size of the button
	[myButton2 setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[myButton2 addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:myButton2];
	self.navigationItem.leftBarButtonItem = backButton;
	self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    self.pickerView = nil;
//    self.myPickerView = nil;
//    self.myTableView = nil;
//    self.parent = nil;
//    self.showView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.showView == @"pickerView")
    {
        self.myTableView.alpha = 0.0;
        self.myPickerView.alpha = 1.0;
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        
        NSString *setting = [self.parent.settings valueForKey:@"max_results"];
        if ([setting isEqualToString:@""])
        {
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
        }
        else
        {
            [self.pickerView selectRow:(([setting intValue]/10)-1) inComponent:0 animated:NO];
        }
    }
    if (self.showView == @"tableView")
    {
        self.myTableView.alpha = 1.0;
        self.myPickerView.alpha = 0.0;
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        
        [self.myTableView reloadData];
    }
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIPickerView data source and delegate methods

- (int) numberOfComponentsInPickerView:(UIPickerView*)picker 
{
	return 1;
}

- (int) pickerView:(UIPickerView*)picker numberOfRowsInComponent:(int)col 
{
	return [self.pickerNumbers count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 37)];
    label.text = [self.pickerNumbers objectAtIndex:row];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label autorelease];
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component 
{
    return 60;
}

#pragma mark - TableView data source and delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
	NSUInteger index = [indexPath row];
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
    {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.opaque = NO;
	}
    if (index == 0)
    {
        cell.textLabel.text = @"Small area";
        if ([self.parent.settings valueForKey:@"bbox"] == @"1" || [[self.parent.settings valueForKey:@"bbox"] intValue] == 1)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (index == 1)
    {
        cell.textLabel.text = @"Medium area";
        if ([self.parent.settings valueForKey:@"bbox"] == @"2" || [[self.parent.settings valueForKey:@"bbox"] intValue] == 2)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (index == 2)
    {
        cell.textLabel.text = @"Large area";
        if ([self.parent.settings valueForKey:@"bbox"] == @"3" || [[self.parent.settings valueForKey:@"bbox"] intValue] == 3)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath 
{
    NSInteger index = [indexPath row];
    if (index == 0)
    {
        [self.parent.settings setValue:@"1" forKey:@"bbox"];
    }
    if (index == 1)
    {
        [self.parent.settings setValue:@"2" forKey:@"bbox"];
    }
    if (index == 2)
    {
        [self.parent.settings setValue:@"3" forKey:@"bbox"];
    }
    
    NSLog(@"%@", self.parent.settings);
    
	[tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - My methods

- (void)setSetting
{
    NSString *pickerValue = [self.pickerNumbers objectAtIndex:[pickerView selectedRowInComponent:0]];
    [self.parent.settings setValue:pickerValue forKey:@"max_results"];
    NSLog(@"%@", self.parent.settings);
    [self backButtonPressed];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
