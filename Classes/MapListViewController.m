//
//  MapListViewController.m
//  Do It
//
//  Created by Vytautas on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapListViewController.h"
#import "CJSONDeserializer.h"
#import "ASIFormDataRequest.h"
#import "CHCSV.h"
#import "PointAnnotation.h"
#import "PointCell.h"
#import "Do_ItViewController.h"
#import <dispatch/dispatch.h>

@implementation MapListViewController

@synthesize appDelegate, mapView, myTableView, nearestPoints, parent, pointViewController, segmentedControl, mapBackButton, mapRefreshButton, loadViewString, navBackButton, loadingBackground, loadingLabel, loadingActivityIndicator;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.appDelegate = [[UIApplication sharedApplication] delegate];
	
    self.loadingBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_bg.png"]];
	self.myTableView.alpha = 0;
    
    self.mapBackButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 55, 30)];
	[self.mapBackButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[self.mapBackButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.mapBackButton];
	
	self.mapRefreshButton = [[UIButton alloc] initWithFrame:CGRectMake(242, 7, 70, 30)];
	[self.mapRefreshButton setBackgroundImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
	[self.mapRefreshButton addTarget:self action:@selector(refreshButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.mapRefreshButton];
    
    // Adding the "Back" button
    self.navBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.navBackButton.frame = CGRectMake(20, 20, 55, 30); // position in the parent view and set the size of the button
	[self.navBackButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[self.navBackButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:self.navBackButton];
	self.navigationItem.leftBarButtonItem = backButton;
	
	mapView.showsUserLocation = YES;
	
	[self loadInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.loadViewString == @"map")
    {
        [self.segmentedControl setSelectedSegmentIndex:0];
        self.loadViewString = @"";
    }
    if (self.loadViewString == @"list")
    {
        [self.segmentedControl setSelectedSegmentIndex:1];
        self.loadViewString = @"";
    }
    if(self.mapView.alpha == 0)
    {
        [self.navigationController setNavigationBarHidden:NO];
        [self.segmentedControl setSelectedSegmentIndex:1];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES];
        [self.segmentedControl setSelectedSegmentIndex:0];
    }
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)switchViews
{
	if(self.mapView.alpha == 0) 
	{
		[self.navigationController setNavigationBarHidden:YES];
		self.mapView.alpha = 1;
		self.myTableView.alpha = 0;
		self.mapBackButton.hidden = NO;
		self.mapRefreshButton.hidden = NO;
	} 
	else 
	{
		[self.navigationController setNavigationBarHidden:NO];
		self.mapView.alpha = 0;
		self.myTableView.alpha = 1;
		self.mapBackButton.hidden = YES;
		self.mapRefreshButton.hidden = YES;
	}
}

#pragma mark -
#pragma mark MKMapView delegate mathods

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation 
{
	if([[annotation title] isEqualToString:@"Current Location"])
		return nil;
	
	MKPinAnnotationView *pinView = (MKPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
	if(pinView == nil) 
    {
		pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
		pinView.animatesDrop = YES;
		pinView.canShowCallout = YES;
		UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		pinView.rightCalloutAccessoryView = rightButton;
	} 
	else 
    {
		pinView.annotation = annotation;
	}
	return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (self.pointViewController == nil)
    {
        self.pointViewController = [[PointViewController alloc] init];
    }
    PointAnnotation *annotation = (PointAnnotation *)view.annotation;
    
    NSString *myID = [annotation.pointData objectForKey:@"id"];
    NSLog(@"ID: %@", myID);
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"style.html"];
    NSString *styleStr = [NSString stringWithContentsOfFile:finalPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *str = [NSString stringWithFormat:@"%@%@", parent.serverUrl, [appDelegate.settings valueForKey:@"stringDetails"]];
    NSString *urlStr = [NSString stringWithFormat:str, myID];
    NSLog(@"%@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSString *source = [request responseString];
        NSString *fullSource = [NSString stringWithFormat:@"<html><head>%@</head><body>%@</body></html>", styleStr, source];
        NSLog(@"%@", fullSource);
        self.pointViewController.fullSource = fullSource;
        
        [self.navigationController pushViewController:self.pointViewController animated:YES];
    }
    else
    {
        NSLog(@"maplistviewcontroller1 %@",[error localizedDescription]);
        NSString *alertString = [NSString stringWithFormat:@"An error occured: %@", [error localizedDescription]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:alertString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - My methods

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshButtonPressed
{
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.nearestPoints];
    [newArray removeAllObjects];
    self.nearestPoints = [NSArray arrayWithArray:newArray];
	
	NSMutableArray *toRemove = [NSMutableArray array];
	for (id annotation in self.mapView.annotations)
		if (annotation != self.mapView.userLocation)
			[toRemove addObject:annotation];
	[self.mapView removeAnnotations:toRemove];
	
	[self loadInfo];
}

- (void)loadInfo
{
    [self.loadingActivityIndicator startAnimating];
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:1.0 animations:nil];
    self.loadingBackground.alpha = 1.0;
    [UIView commitAnimations];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       self.nearestPoints = [self getNearestPoints:parent.locationManager.location];
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [UIView beginAnimations:nil context:nil];
                                          [UIView animateWithDuration:1.0 animations:nil];
                                          self.loadingBackground.alpha = 0.0;
                                          [self.loadingActivityIndicator stopAnimating];
                                          [UIView commitAnimations];
                                          if (self.nearestPoints == nil)
                                          {
                                              NSLog(@"loadInfo error, no nearest");

                                              NSString *alertString = [NSString stringWithFormat:@"An error occured: no nearest"];
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                                              message:alertString
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                              [alert release];
 
                                          }
                                          [self initMap];
                                          [self.myTableView reloadData];
                                      });
                   });
}

- (void)initMap 
{	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.001f;
	span.longitudeDelta = 0.001f;
	
	CLLocationCoordinate2D location;
	location.latitude = parent.locationManager.location.coordinate.latitude;
	location.longitude = parent.locationManager.location.coordinate.longitude;
	
	mapView.region = MKCoordinateRegionMakeWithDistance(location, 10000,10000);
	[mapView regionThatFits:region];
    
    for(NSDictionary *point in self.nearestPoints) 
	{
		PointAnnotation *annotation = [[PointAnnotation alloc] initWithPointData:point];
		[mapView addAnnotation:annotation];
		[annotation release];
	} 
}

#pragma mark -
#pragma mark Accessing the cloud

- (NSMutableArray *)getNearestPoints:(CLLocation *)center 
{
	NSString *latitude = [NSString stringWithFormat:@"%g", center.coordinate.latitude];
	NSString *longitude = [NSString stringWithFormat:@"%g", center.coordinate.longitude];		
    NSString *serverUrl = parent.serverUrl;
    NSString *stringEnd = [appDelegate.settings objectForKey:@"stringNearest"];
    NSString *str = [NSString stringWithFormat:@"%@%@", serverUrl, stringEnd];
    NSString *newURL = [NSString stringWithFormat:str, [[self.parent.settings objectForKey:@"max_results"] intValue], longitude, latitude];
    NSLog(@"%@", newURL);
    NSURL *myURL = [NSURL URLWithString:newURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:myURL];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSString *csv = [request responseString];
        NSArray *rows = [NSArray arrayWithContentsOfCSVString:csv encoding:NSUTF8StringEncoding error:nil];
        if([rows count] == 0){
            return nil;
        }
        
        if ([rows count] == 1)
        {
            stringEnd = [appDelegate.settings objectForKey:@"stringBBOX"];
            str = [NSString stringWithFormat:@"%@%@", serverUrl, stringEnd];
            NSInteger BBOX = [[self.parent.settings objectForKey:@"bbox"] intValue];
            NSString *lon1 = [NSString stringWithFormat:@"%f", [longitude floatValue] - BBOX];
            NSString *lat1 = [NSString stringWithFormat:@"%f", [latitude floatValue] - (float)(2*BBOX)/3];
            NSString *lon2 = [NSString stringWithFormat:@"%f", [longitude floatValue] + BBOX];
            NSString *lat2 = [NSString stringWithFormat:@"%f", [latitude floatValue] + (float)(2*BBOX)/3];
            newURL = [NSString stringWithFormat:str, [[self.parent.settings objectForKey:@"max_results"] intValue], lon1, lat1, lon2, lat2];
            NSLog(@"%@", newURL);
            myURL = [NSURL URLWithString:newURL];
            csv = [NSString stringWithContentsOfURL:myURL encoding:NSUTF8StringEncoding error:nil];
            rows = [NSArray arrayWithContentsOfCSVString:csv encoding:NSUTF8StringEncoding error:nil];
        }
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (int i = 1; i < [rows count] - 1; i++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            for (int j = 0; j < [[rows objectAtIndex:0] count]; j++)
            {
                [dic setObject:[[rows objectAtIndex:i] objectAtIndex:j] forKey:[[rows objectAtIndex:0] objectAtIndex:j]];
            }
            [mutableArray addObject:dic];
            [dic release];
        }
        
        NSArray* sortedArray = [mutableArray sortedArrayUsingComparator:^(id obj1, id obj2){
            float v1 = [(NSString*) [obj1 objectForKey:@"distance_meters"] floatValue];
            float v2 = [(NSString*) [obj2 objectForKey:@"distance_meters"] floatValue];
            
            if (v1 > v2) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else if (v1 < v2) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
            return (NSComparisonResult)NSOrderedSame;
        }];

        
        NSLog(@"SORTED: \n%@", sortedArray);
        
        return [sortedArray mutableCopy];
    }
    else
    {
        return nil;
    }
    return nil;
}


- (NSString *)getDistanceToPoint:(NSDictionary *)point
{
    float latitude = [[point objectForKey:@"lat"] floatValue];
    float longitude = [[point objectForKey:@"lon"] floatValue];
    CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    NSString *result = [NSString stringWithFormat:@"%d", abs([pointLocation distanceFromLocation:parent.locationManager.location])/1000];
    return result;
}

#pragma mark -
#pragma mark TableView data source and delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"PointCellIndentifier";
    NSInteger index = [indexPath row];
    PointCell *cell = (PointCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PointCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (PointCell *)currentObject;
            }
        }
    }
    NSDictionary *currentPoint = [nearestPoints objectAtIndex:index];
    NSMutableArray *pictures = [[NSMutableArray alloc] init];
    
    NSString *test = [currentPoint objectForKey:@"composition_glass"];
    if (![test isEqualToString:@"0"])
    {
        [pictures addObject:[NSString stringWithFormat:@"glass.png"]];
    }
    test = [currentPoint objectForKey:@"composition_large"];
    if (![test isEqualToString:@"0"])
    {
        [pictures addObject:[NSString stringWithFormat:@"large.png"]];
    }
    test = [currentPoint objectForKey:@"composition_paper"];
    if (![test isEqualToString:@"0"])
    {
        [pictures addObject:[NSString stringWithFormat:@"paper.png"]];
    }
    
    if ([currentPoint objectForKey:@"composition_pmp"])
    {
        test = [currentPoint objectForKey:@"composition_pmp"];
        if (![test isEqualToString:@"0"])
        {
            [pictures addObject:[NSString stringWithFormat:@"pmp.png"]];
        }
    }
    else
    {
        test = [currentPoint objectForKey:@"composition_plastic"];
        if (![test isEqualToString:@"0"])
        {
            [pictures addObject:[NSString stringWithFormat:@"pmp.png"]];
        }
    }
    
    for (int i = 0; i < [pictures count]; i++)
    {
        CGRect imageViewRect;
        if (i == 0)
            imageViewRect = CGRectMake(96, 5, 33, 33); 
        else
        {
            imageViewRect = CGRectMake(96+(38*i), 5, 33, 33);
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewRect]; 
        NSString *imagePath = [pictures objectAtIndex:i];
        imageView.image = [UIImage imageNamed:imagePath];
        [cell addSubview:imageView];
    }
    [pictures release];
	cell.idLabel.text = [currentPoint objectForKey:@"id"];
    cell.rangeLabel.text = [self getDistanceToPoint:currentPoint];
	return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath 
{
    NSInteger index = [indexPath row];
    if (self.pointViewController == nil)
    {
        self.pointViewController = [[PointViewController alloc] init];
    }
    NSString *myID = [[self.nearestPoints objectAtIndex:index] valueForKey:@"id"];
    NSLog(@"ID: %@", myID);
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"style.html"];
    NSString *styleStr = [NSString stringWithContentsOfFile:finalPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *str = [NSString stringWithFormat:@"%@%@", parent.serverUrl, [appDelegate.settings valueForKey:@"stringDetails"]];
    NSString *urlStr = [NSString stringWithFormat:str, myID];
    NSLog(@"%@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [self.loadingActivityIndicator startAnimating];
    self.loadingBackground.alpha = 1.0;
    [UIView commitAnimations];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                       [request startSynchronous];
                       NSError *error = [request error];
                       if (!error)
                       {
                           NSString *source = [request responseString];
                           NSString *fullSource = [NSString stringWithFormat:@"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />%@</head><body>%@</body></html>", styleStr, source];
                           NSLog(@"%@", fullSource);
                           self.pointViewController.fullSource = fullSource;
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              [UIView beginAnimations:nil context:nil];
                                              [UIView setAnimationDuration:1.0];
                                              [self.loadingActivityIndicator stopAnimating];
                                              self.loadingBackground.alpha = 0.0;
                                              [UIView commitAnimations];
                                              
                                              [self.navigationController pushViewController:self.pointViewController animated:YES];
                                          });
                       }
                       else
                       {
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              [UIView beginAnimations:nil context:nil];
                                              [UIView setAnimationDuration:1.0];
                                              [self.loadingActivityIndicator stopAnimating];
                                              self.loadingBackground.alpha = 0.0;
                                              [UIView commitAnimations];
                                              NSLog(@"maplistviewcontroller2 %@",[error localizedDescription]);
   
                                              NSString *alertString = [NSString stringWithFormat:@"An error occured: %@", [error localizedDescription]];
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                                              message:alertString
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                              [alert release];
                                          });
                       }
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [tableView deselectRowAtIndexPath:indexPath animated:YES];                                          
                                      });
                   });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [nearestPoints count];
}

#pragma mark -

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//	self.appDelegate = nil;
//	self.mapView = nil;
//	self.myTableView = nil;
//	self.nearestPoints = nil;
//    self.parent = nil;
//    self.pointViewController = nil;
//    self.segmentedControl = nil;
//    self.mapBackButton = nil;
//    self.mapRefreshButton = nil;
//    self.loadViewString = nil;
//    self.navBackButton = nil;
//    self.loadingBackground = nil;
//    self.loadingLabel = nil;
//    self.loadingActivityIndicator = nil;
}


- (void)dealloc 
{
	[appDelegate release];
	[mapView release];
	[myTableView release];
	[nearestPoints release];
    [parent release];
    [pointViewController release];
    [segmentedControl release];
    [mapBackButton release];
    [mapRefreshButton release];
    [loadViewString release];
    [navBackButton release];
    [loadingBackground release];
    [loadingLabel release];
    [loadingActivityIndicator release];
    [super dealloc];
}


@end
