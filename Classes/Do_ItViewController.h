//
//  Do_ItViewController.h
//  Do It
//
//  Created by Vytautas on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Do_ItAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@class AddNewViewController;
@class MapListViewController;
@class SettingsViewController;
@class LoginViewController;
@class Reachability;

@interface Do_ItViewController : UIViewController <CLLocationManagerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
	Do_ItAppDelegate *appDelegate;
    NSString *serverUrl;
	CLLocationManager *locationManager;
    MapListViewController *mapListViewController;
    AddNewViewController *addNewViewController;
    NSMutableDictionary *settings;
    SettingsViewController *settingsViewController;
    LoginViewController *loginViewController;
    Reachability *internetReachable;
    BOOL connection;
    IBOutlet UIButton *mapButton;
    IBOutlet UIButton *listButton;
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *settingsButton;
    IBOutlet UIView *loadingBackground;
    IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
    UIImagePickerController *imagePickerController;
}
@property (nonatomic, retain) Do_ItAppDelegate *appDelegate;
@property (nonatomic, retain) NSString *serverUrl;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) MapListViewController *mapListViewController;
@property (nonatomic, retain) AddNewViewController *addNewViewController;
@property (nonatomic, retain) NSMutableDictionary *settings;
@property (nonatomic, retain) SettingsViewController *settingsViewController;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) Reachability *internetReachable;
@property BOOL connection;
@property (nonatomic, retain) IBOutlet UIButton *mapButton;
@property (nonatomic, retain) IBOutlet UIButton *listButton;
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) IBOutlet UIButton *settingsButton;
@property (nonatomic, retain) IBOutlet UIView *loadingBackground;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;

- (IBAction)mapPressed;
- (IBAction)listPressed;
- (IBAction)addNew;
- (IBAction)settingsPressed;

@end

