//
//  MapListViewController.h
//  Do It
//
//  Created by Vytautas on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Do_ItAppDelegate.h"
#import "PointViewController.h"
#import "TileOverlay.h"

@class Do_ItViewController;

@interface MapListViewController : UIViewController <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
	Do_ItAppDelegate *appDelegate;
	IBOutlet MKMapView *mapView;
	IBOutlet UITableView *myTableView;
	NSMutableArray *nearestPoints;
    Do_ItViewController *parent;
    PointViewController *pointViewController;
    IBOutlet UISegmentedControl *segmentedControl;
    UIButton *mapBackButton;
    UIButton *mapRefreshButton;
    UIButton *navBackButton;
    NSString *loadViewString;
    IBOutlet UIView *loadingBackground;
    IBOutlet UILabel *loadingLabel;
    IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
}

@property (nonatomic, retain) Do_ItAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *nearestPoints;
@property (nonatomic, retain) Do_ItViewController *parent;
@property (nonatomic, retain) PointViewController *pointViewController;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UIButton *mapBackButton;
@property (nonatomic, retain) UIButton *mapRefreshButton;
@property (nonatomic, retain) UIButton *navBackButton;
@property (nonatomic, retain) NSString *loadViewString;
@property (nonatomic, retain) IBOutlet UIView *loadingBackground;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@property (nonatomic, retain) TileOverlay *overlay;

- (IBAction)switchViews;
- (NSMutableArray *)getNearestPoints:(CLLocation *)center;
- (void)initMap;
- (NSString *)getDistanceToPoint:(NSDictionary *)point;
- (void)backButtonPressed;
- (void)refreshButtonPressed;
- (void)loadInfo;

@end
