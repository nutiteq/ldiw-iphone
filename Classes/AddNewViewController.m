//
//  AddNewViewController.m
//  Do It
//
//  Created by Vytautas on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddNewViewController.h"
#import "Do_ItViewController.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import "TextEditViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "CJSONDeserializer.h"
#import <dispatch/dispatch.h>
#import "CoordinateAnnotation.h"
#import "UIImage+ProportionalFill.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PointAnnotation.h"
#import "TileOverlay.h"
#import "TileOverlayView.h"

#define degreesToRadian(x) (M_PI * x / 180.0)

@implementation AddNewViewController

@synthesize parent, appDelegate, fieldsInfo, myTableView, switches, textEditViewController, collectedInfo, photo, imagePickerController, collectedData, sessionId, sessionName, loadingBackground, loadingActivityIndicator, mapView, imageLocation, mapListViewController,overlay;
//sectionTitles

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
    [appDelegate release];
    [myTableView release];
//  [sectionTitles release];
    [switches release];
    [textEditViewController release];
    [collectedInfo release];
    [photo release];
    [imagePickerController release];
    [collectedData release];
    [sessionId release];
    [sessionName release];
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
    self.switches = [NSMutableDictionary dictionary];
    
    self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.loadingBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_bg.png"]];
    
    // Parsing info
    NSString *fieldsStr = [appDelegate.settings objectForKey:@"stringFields"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.parent.serverUrl, fieldsStr];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) 
    {
        NSString *responseStr = [NSString stringWithFormat:@"{\"root\":%@}", [request responseString]];
        NSLog(@"%@", responseStr);
        NSData *responseData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
		NSError *error2 = nil;
		NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:responseData error:&error2];
        if(!error2)
		{
            NSMutableArray *results = [resultsDictionary objectForKey:@"root"];
            NSLog(@"%@", results); 
            self.fieldsInfo = results;
        }
        else
        {
            NSLog(@"%@", [error2 localizedDescription]);
        }
    }
    else
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    
//    // Managing the titles of sections
//    self.sectionTitles = [[NSMutableArray alloc] init];
//    NSString *first = @"";
//    [self.sectionTitles addObject:first];

    for (NSDictionary *dic in self.fieldsInfo)
    {
        if ([dic valueForKey:@"type"] == @"begin_section")
        {
//            NSString *titleString = [dic objectForKey:@"label"];
//            [self.sectionTitles addObject:titleString];
            [self.fieldsInfo removeObject:dic];
        }
    }
    
    // Adding the "Add" button
    UIImage *myImage = [UIImage imageNamed:@"add.png"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:myImage forState:UIControlStateNormal];
//  myButton.showsTouchWhenHighlighted = YES;
    myButton.frame = CGRectMake(0, 0, 60, 30);
    
    [myButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
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
    
    // Creating the collected info dictionary
    if (self.collectedData == nil) 
    {
        self.collectedData = [NSMutableDictionary dictionary];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    self.parent = nil;
//    self.appDelegate = nil;
//    self.myTableView = nil;
////  self.sectionTitles = nil;
//    self.switches = nil;
//    self.textEditViewController = nil;
//    self.collectedInfo = nil;
//    self.photo = nil;
//    self.imagePickerController = nil;
//    self.collectedData = nil;
//    self.sessionName = nil;
//    self.sessionId = nil;
//    self.loadingActivityIndicator = nil;
//    self.loadingBackground = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.myTableView reloadData];
    self.loadingBackground.alpha = 0.0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.loadingBackground.alpha = 0.0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - My Methods

- (void)add
{
    // unique ID
	NSString *myStr = [NSString stringWithFormat:@"%@%@", [[UIDevice currentDevice] uniqueIdentifier], @"doit"];
	const char *cStr = [myStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
	NSString *md5str = [NSString stringWithFormat:
						@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
						result[0], result[1], result[2], result[3], 
						result[4], result[5], result[6], result[7],
						result[8], result[9], result[10], result[11],
						result[12], result[13], result[14], result[15]
						]; 
    [self.collectedData setValue:md5str forKey:@"client_id"];
    
    // lat & lon
    
    NSLog(@"image location: %g %g",imageLocation.coordinate.latitude,imageLocation.coordinate.longitude);
    NSLog(@"locationManager location: %g %g",parent.locationManager.location.coordinate.latitude,parent.locationManager.location.coordinate.longitude);
    
    CLLocation* location = abs(imageLocation.coordinate.latitude) > 0.1 && abs(imageLocation.coordinate.longitude)>0.1 ? 
        imageLocation : parent.locationManager.location;

    NSString *lat = [NSString stringWithFormat:@"%g", location.coordinate.latitude];
	NSString *lon = [NSString stringWithFormat:@"%g", location.coordinate.longitude];
	[self.collectedData setValue:lat forKey:@"lat"];
    [self.collectedData setValue:lon forKey:@"lon"];
    
    // switches
    for (NSString *key in self.switches)
    {
        UISwitch *sw = [self.switches objectForKey:key];
        NSString *status;
        if (sw.on)
            status = @"1";
        else
            status = @"0";
        [self.collectedData setObject:status forKey:key];
    }
    
     NSLog(@"%@", self.collectedData);
    
    // photo
    if (self.photo) 
    {
        NSData *photoData = UIImageJPEGRepresentation(self.photo, 0.6f);
        NSLog(@"adding photo size: %d",[photoData length]);
        [self.collectedData setObject:photoData forKey:@"photo_file_1"];    
    }
        
    // sending the info
    NSString *fieldsStr = [appDelegate.settings objectForKey:@"stringAdd"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.parent.serverUrl, fieldsStr];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    for (NSString *key in self.collectedData)
    {
        if ([[self.collectedData objectForKey:key] isKindOfClass:[NSString class]])
        {
            [request addPostValue:[self.collectedData objectForKey:key] forKey:key];
        }
        if ([[self.collectedData objectForKey:key] isKindOfClass:[NSData class]])
        {
            [request addData:[self.collectedData objectForKey:key] forKey:key];
        }
    }
    [request setRequestCookies:nil];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [self.loadingActivityIndicator startAnimating];
    self.loadingBackground.alpha = 1.0;
    [UIView commitAnimations];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       [request startSynchronous];
                       NSLog(@"res: %@",[request responseString]);
                       NSError *error = [request error];
                       if (!error)
                       {
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              [UIView beginAnimations:nil context:nil];
                                              [UIView setAnimationDuration:1.0];
                                              [self.loadingActivityIndicator stopAnimating];
                                              self.loadingBackground.alpha = 0.0;
                                              [UIView commitAnimations];
                                              
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" 
                                                                                              message:@"New waste point added."
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                              [alert release];
                                              [self backButtonPressed]; 
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
                                              
                                              NSLog(@"Error: %@", [error localizedDescription]);
                                              NSLog(@"%@", [request responseString]);
                                              NSString *alertString = [NSString stringWithFormat:@"Upload error occured: %@", [error localizedDescription]];
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                                              message:alertString
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                              [alert release];
                                          });
                       }
                   });
}

- (void)backButtonPressed 
{
	[self.navigationController popViewControllerAnimated:YES];
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
    NSDictionary *currentField = [self.fieldsInfo objectAtIndex:index];

    NSString *title = [currentField objectForKey:@"label"];

    
    switch ([indexPath section]) {
        case 0:
            cell.textLabel.text = title;
            if ([[currentField objectForKey:@"type"] isEqualToString:@"number"] || [[currentField objectForKey:@"type"] isEqualToString:@"integer"] || [[currentField objectForKey:@"type"] isEqualToString:@"float"]) 
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if ([[currentField objectForKey:@"type"] isEqualToString:@"text"]) 
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if ([[currentField objectForKey:@"type"] isEqualToString:@"boolean"]) 
            {
                UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(206, 8, 94, 27)];
                [cell addSubview:sw];
                [self.switches setObject:sw forKey:[currentField objectForKey:@"field_name"]];
            }

            break;
        case 1:
            cell.textLabel.text = @"Take A Picture";
            cell.imageView.image = photo;

            break;
            
        case 2: // special field: map view
            if(self.mapView == nil){
                self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 120.0f)];
                self.mapView.delegate=self;
                
                // OpenStreetMap based on http://wiki.openstreetmap.org/wiki/OSM_in_MapKit
                overlay = [[TileOverlay alloc] initOverlay];
                [mapView addOverlay:overlay];
              /*  MKMapRect visibleRect = [mapView mapRectThatFits:overlay.boundingMapRect];
                visibleRect.size.width /= 2;
                visibleRect.size.height /= 2;
                visibleRect.origin.x += visibleRect.size.width / 2;
                visibleRect.origin.y += visibleRect.size.height / 2;
                mapView.visibleMapRect = visibleRect;
                */
                //    self.mapView.mapType = MKMapTypeHybrid;
                
            }
            
            CLLocation* location = CLLocationCoordinate2DIsValid(imageLocation.coordinate) ? imageLocation : parent.locationManager.location;

            [mapView removeAnnotations:[mapView annotations]];
            
            CLLocationCoordinate2D coord = {
                    .latitude = location.coordinate.latitude,
                    .longitude = location.coordinate.longitude
                };
            
            if (CLLocationCoordinate2DIsValid(coord)){
            MKCoordinateSpan span = {.latitudeDelta = 0.01, .longitudeDelta= 0.01};
            MKCoordinateRegion region = {coord, span};
            
            // annotation for user location
            CoordinateAnnotation *annotation = [[CoordinateAnnotation alloc] initWithCoordinate:coord];
            [mapView addAnnotation:annotation];
            
            if (self.mapListViewController == nil)
            {
               self.mapListViewController = [[MapListViewController alloc] init];
               self.mapListViewController.parent = parent;
               self.mapListViewController.appDelegate = appDelegate;
                
            }
            
//            [self.mapListViewController loadInfo];
            
            NSMutableArray* nearestPoints = [self.mapListViewController getNearestPoints:location];
            NSLog(@"nearest points: %d",[nearestPoints count]);
                                         
            for(NSDictionary *point in nearestPoints) 
            {
                PointAnnotation *annotation = [[PointAnnotation alloc] initWithPointData:point];
                [mapView addAnnotation:annotation];
                [annotation release];
            } 

             [mapView setRegion:region];
            }
            
            mapView.showsUserLocation = YES;
            [cell.contentView addSubview:mapView];
            break;

        default:
            break;
    } // switch
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath 
{
    NSDictionary *currentField = [self.fieldsInfo objectAtIndex:[indexPath row]];

    // Show the confirmation.
    
    UIActionSheet *alert = [[UIActionSheet alloc] 
                            initWithTitle: NSLocalizedString(@"Add Photo",nil)
                            delegate: self
                            cancelButtonTitle: NSLocalizedString(@"Cancel",nil)
                            destructiveButtonTitle: nil
                            otherButtonTitles: NSLocalizedString(@"Take Photo",nil),
                            NSLocalizedString(@"Choose From Library",nil),
                            nil,
                            nil];
    
    // use the same style as the nav bar
    alert.actionSheetStyle = self.navigationController.navigationBar.barStyle;
    
    switch ([indexPath section]){
        case 0:
            if (![[currentField objectForKey:@"type"] isEqualToString:@"boolean"]) 
            {
                if (self.textEditViewController == nil)
                {
                    self.textEditViewController = [[TextEditViewController alloc] init];
                    self.textEditViewController.parent = self;
                }
                self.textEditViewController.currentField = currentField;
                [self.navigationController pushViewController:textEditViewController animated:YES];
            }
            break;
            
        case 1: // special section: image picker
            
            [alert showInView:self.view];
            
          } // switch
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == 0) 
    {
        return [self.fieldsInfo count];
    }
	return 1;
}

- (CGFloat)tableView:(UITableView *)tabelView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat result;
	
	switch([indexPath section]) {
			
		case 2:
			result = 120;
			break;
        default:
            result = 44;
			
	}
	
	return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSInteger count = 1;
//    for (NSDictionary *dic in self.fieldsInfo)
//    {
//        if ([dic valueForKey:@"type"] == @"begin_section")
//            count = count + 1;
//    }
//    return count;
    return 3;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *title = [self.sectionTitles objectAtIndex:section];
//    return title;
//}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clicked %d",buttonIndex);
    
    switch (buttonIndex) {
        case 0: // camera
            if (self.imagePickerController == nil)
            {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                [self.loadingActivityIndicator startAnimating];
                self.loadingBackground.alpha = 1.0;
                [UIView commitAnimations];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                               {
                                   imagePickerController = [[UIImagePickerController alloc] init];
                                   imagePickerController.delegate = self;
                                   imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                   dispatch_async(dispatch_get_main_queue(), ^
                                                  {
                                                      [UIView beginAnimations:nil context:nil];
                                                      [UIView setAnimationDuration:0.5];
                                                      [self.loadingActivityIndicator stopAnimating];
                                                      self.loadingBackground.alpha = 0.0;
                                                      [UIView commitAnimations];
                                                      
                                                      [self.navigationController presentModalViewController:imagePickerController animated:YES];
                                                  });
                               });
                
            }
            else
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.navigationController presentModalViewController:imagePickerController animated:YES];
            }
            self.imageLocation = nil;
            
            break;
            
        case 1: // Library
            if (self.imagePickerController == nil)
            {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                [self.loadingActivityIndicator startAnimating];
                self.loadingBackground.alpha = 1.0;
                [UIView commitAnimations];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                               {
                                   imagePickerController = [[UIImagePickerController alloc] init];
                                   imagePickerController.delegate = self;
                                   imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                   dispatch_async(dispatch_get_main_queue(), ^
                                                  {
                                                      [UIView beginAnimations:nil context:nil];
                                                      [UIView setAnimationDuration:0.5];
                                                      [self.loadingActivityIndicator stopAnimating];
                                                      self.loadingBackground.alpha = 0.0;
                                                      [UIView commitAnimations];
                                                      
                                                      [self.navigationController presentModalViewController:imagePickerController animated:YES];
                                                  });
                               });
                
            }
            else
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController presentModalViewController:imagePickerController animated:YES];
            }
            
            break;
    } // switch
}

#pragma mark - UIImagePickerController delegate and resize methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
	[picker dismissModalViewControllerAnimated:YES];
	UIImage *bigPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
 
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        NSLog(@"writing to photo album");
        UIImageWriteToSavedPhotosAlbum(bigPhoto, nil, nil, nil);
    }
    
    self.photo = [bigPhoto imageScaledToFitSize:CGSizeMake(720, 540)];  

    // try to find coordinates (from EXIF)
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
             resultBlock:^(ALAsset *asset)
     {
         CLLocation* location = [asset valueForProperty:ALAssetPropertyLocation];
         if(location){
             CLLocationCoordinate2D coord = [location coordinate];
             self.imageLocation = location;
             NSLog(@"image location: %f %f", coord.latitude, coord.longitude);
         }
        
         [library autorelease];
     }
            failureBlock:^(NSError *error)
     {
         NSLog(@"couldn't get asset: %@", error);
         
         [library autorelease];
     }
     ];
    
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark MKMapView delegate mathods

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation 
{
	if([annotation isKindOfClass:[MKUserLocation class]])
		return nil;

    if([annotation isKindOfClass:[PointAnnotation class]])
		return nil;

    
	MKPinAnnotationView *pinView = (MKPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
	if(pinView == nil) 
    {
		pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        pinView.pinColor = MKPinAnnotationColorPurple;
    } 
	else 
    {
		pinView.annotation = annotation;
	}
	return pinView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)ovl
{
    TileOverlayView *view = [[TileOverlayView alloc] initWithOverlay:ovl];
    view.tileAlpha = 1.0; // e.g. 0.6 alpha for semi-transparent overlay
    return [view autorelease];
}

/*
 // seems to be problematic with non-camera (library) images
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize
{  
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }     
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }   
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, degreesToRadian(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, degreesToRadian(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, degreesToRadian(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage; 
}
*/
@end
