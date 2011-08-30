//
//  LoginViewController.m
//  Do It
//
//  Created by Vytautas on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "Do_ItViewController.h"
#import "AddNewViewController.h"
#import "Do_ItAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import <dispatch/dispatch.h>

@implementation LoginViewController

@synthesize imageView, usernameTextField, passwordTextField, parent, appDelegate, loadingBackground, loadingActivityIndicator;

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
    [imageView release];
    [usernameTextField release];
    [passwordTextField release];
    [parent release];
    [appDelegate release];
    [loadingBackground release];
    [loadingActivityIndicator release];
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
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.imageView.image = [UIImage imageNamed:@"head.png"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 55, 30)];
	[backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backButton];
	
	UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(255, 7, 60, 30)];
	[okButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
	[okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:okButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.loadingBackground.alpha = 0.0;
    self.navigationItem.hidesBackButton = YES;
    [self.usernameTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    self.imageView = nil;
//    self.usernameTextField = nil;
//    self.passwordTextField = nil;
//    self.parent = nil;
//    self.appDelegate = nil;
//    self.loadingActivityIndicator = nil;
//    self.loadingBackground = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{   
    if (textField == self.usernameTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        [self.passwordTextField resignFirstResponder];
        [self okButtonPressed];
    }
    return NO;
}

#pragma mark - My methods

- (void)backButtonPressed
{
    [self.appDelegate.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)okButtonPressed
{
    if (self.usernameTextField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Please enter the username" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }
    if (self.usernameTextField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Please enter the password" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    [self.passwordTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    
    // Connecting to Login
    NSString *loginStr = [appDelegate.settings objectForKey:@"stringLogin"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.parent.serverUrl, loginStr];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request addPostValue:self.usernameTextField.text forKey:@"username"];
    [request addPostValue:self.passwordTextField.text forKey:@"password"];
    [request setRequestCookies:nil];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [self.loadingActivityIndicator startAnimating];
    self.loadingBackground.alpha = 1.0;
    [UIView commitAnimations];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       [request startSynchronous];
                       NSError *error = [request error];
                       if (!error)
                       {
                           CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
                           NSError *error2 = nil;
                           NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:[request responseData] error:&error2];
                           if(!error2)
                           {
                               NSLog(@"%@", resultsDictionary);
                               
                               if (self.parent.addNewViewController == nil)
                               {
                                   self.parent.addNewViewController = [[AddNewViewController alloc] init];
                                   self.parent.addNewViewController.parent = self.parent;
                               }
                               
                               self.parent.addNewViewController.sessionId = [resultsDictionary objectForKey:@"sessid"];
                               self.parent.addNewViewController.sessionName = [resultsDictionary objectForKey:@"session_name"];
                               
                               dispatch_async(dispatch_get_main_queue(), ^
                                              {
                                                  [UIView beginAnimations:nil context:nil];
                                                  [UIView setAnimationDuration:1.0];
                                                  [self.loadingActivityIndicator stopAnimating];
                                                  self.loadingBackground.alpha = 0.0;
                                                  [UIView commitAnimations];
                                                  
                                                  [self.appDelegate.navigationController dismissModalViewControllerAnimated:YES];
                                                  [self.appDelegate.navigationController pushViewController:self.parent.addNewViewController animated:YES];
                                              });
                           }
                           else
                           {
                               NSLog(@"%@", [error2 localizedDescription]);
                           }
                       }
                       else
                       {
                           NSLog(@"Error: %@", [error localizedDescription]);
                           if ([error code] == 3)
                           {
                               dispatch_async(dispatch_get_main_queue(), ^
                                              {
                                                  [UIView beginAnimations:nil context:nil];
                                                  [UIView setAnimationDuration:1.0];
                                                  [self.loadingActivityIndicator stopAnimating];
                                                  self.loadingBackground.alpha = 0.0;
                                                  [UIView commitAnimations];
                                                  
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                                                  message:@"Username or password is wrong" 
                                                                                                 delegate:nil 
                                                                                        cancelButtonTitle:@"OK" 
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                                  [alert release];
                                              });
                           }
                       }
                   });
}

@end
