//
//  SettingsViewController.m
//  Do It
//
//  Created by Vytautas on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "Do_ItViewController.h"
#import "EditSettingsViewController.h"

@implementation SettingsViewController

@synthesize parent, myTableView, editSettingsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [parent release];
    [myTableView release];
    [editSettingsViewController release];
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
    
    // Adding the "Back" button
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
	myButton.frame = CGRectMake(20, 20, 55, 30); // position in the parent view and set the size of the button
	[myButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[myButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
	self.navigationItem.leftBarButtonItem = backButton;
	self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    self.parent = nil;
//    self.myTableView = nil;
//    self.editSettingsViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView data source and delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
	NSUInteger index = [indexPath row];
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) 
    {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.opaque = NO;
	}
    if (index == 0)
    {
        cell.textLabel.text = @"Map area size";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (index == 1)
    {
        cell.textLabel.text = @"Maximum number of results";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath 
{
    NSInteger index = [indexPath row];
    if (index == 0)
    {
        if (self.editSettingsViewController == nil)
        {
            self.editSettingsViewController = [[EditSettingsViewController alloc] init];
            self.editSettingsViewController.parent = self.parent;
        }
        self.editSettingsViewController.showView = @"tableView";
        [self.navigationController pushViewController:self.editSettingsViewController animated:YES];
    }
    if (index == 1)
    {
        if (self.editSettingsViewController == nil)
        {
            self.editSettingsViewController = [[EditSettingsViewController alloc] init];
            self.editSettingsViewController.parent = self.parent;
        }
        self.editSettingsViewController.showView = @"pickerView";
        [self.navigationController pushViewController:self.editSettingsViewController animated:YES];
    }
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [self.parent.settings count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - My methods

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
    
    // Saving the settings
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
    [self.parent.settings writeToFile:path atomically:NO];
}

@end
