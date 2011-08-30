//
//  PointViewController.m
//  Do It
//
//  Created by Vytautas on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PointViewController.h"
#import "CJSONDeserializer.h"
#import "Do_ItViewController.h"
#import "ASIHTTPRequest.h"

@implementation PointViewController

@synthesize webView, fullSource, loadingBackground, loadingActivityIndicator; 

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
    [webView release];
    [fullSource release];
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
    
    self.loadingBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_bg.png"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
   
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [webView loadHTMLString:self.fullSource baseURL:baseURL];
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    // Adding the "Back" button
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
	myButton.frame = CGRectMake(20, 20, 55, 30); // position in the parent view and set the size of the button
	[myButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[myButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
	self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    self.webView = nil;
//    self.fullSource = nil;
//    self.loadingActivityIndicator = nil;
//    self.loadingBackground = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - My methods

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [self.loadingActivityIndicator startAnimating];
    self.loadingBackground.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [self.loadingActivityIndicator stopAnimating];
    self.loadingBackground.alpha = 0.0;
    [UIView commitAnimations];
}

@end
