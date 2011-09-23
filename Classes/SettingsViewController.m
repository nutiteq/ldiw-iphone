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
#import "LoginViewController.h"


@implementation SettingsViewController

@synthesize parent, myTableView, editSettingsViewController,loginViewController;

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
    [self.myTableView reloadData];
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
    NSUInteger section = [indexPath section];
	NSUInteger index = [indexPath row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) 
    {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.opaque = NO;
	}
    switch(section){
        case 0:
            switch(index){
                case 0:
                    cell.textLabel.text = @"Map area size";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 1:
                    cell.textLabel.text = @"Maximum number of results";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 2:
                    cell.textLabel.text = @"Map type";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
            }
            break;
        case 1:
            
            if([self.parent.settings valueForKey:@"mail"] == nil){
                cell.textLabel.text = @"Login";
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"Logout %@",[self.parent.settings valueForKey:@"mail"]];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath 
{
    NSUInteger section = [indexPath section];
    NSInteger index = [indexPath row];
    
    if (self.editSettingsViewController == nil)
    {
        self.editSettingsViewController = [[EditSettingsViewController alloc] init];
        self.editSettingsViewController.parent = self.parent;
    }
    switch(section){
        case 0:
            switch(index){
                case 0:
                    self.editSettingsViewController.showView = @"tableView";
                    [self.navigationController pushViewController:self.editSettingsViewController animated:YES];
                    break;
                case 1:
                    self.editSettingsViewController.showView = @"pickerView";
                    [self.navigationController pushViewController:self.editSettingsViewController animated:YES];
                    break;
                case 2:
                    self.editSettingsViewController.showView = @"mapTypeView";
                    [self.navigationController pushViewController:self.editSettingsViewController animated:YES];
                    break;
            }
            break;
        case 1:
            
           if([self.parent.settings valueForKey:@"mail"] == nil){
               // login
               if (self.loginViewController == nil)
               {
                   
                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                                  {
                                      self.loginViewController = [[LoginViewController alloc] init];
                                      self.loginViewController.parent = self.parent;
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^
                                                     {
                                                         [self.navigationController presentModalViewController:loginViewController animated:YES];
                                                     });
                                  });
               }else{
                   [self.navigationController presentModalViewController:loginViewController animated:YES];
               }
           }else{
               // logout and clean cookie
               [self.parent.settings setValue:nil forKey:@"mail"];
               
               NSURL *url = [NSURL URLWithString:self.parent.serverUrl];
               NSHTTPCookie *cookie = [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url] objectAtIndex:0];
               [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
               [self.myTableView reloadData];
           }

            break;
    }
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if(section == 0){
        return 3; // [self.parent.settings count];
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
