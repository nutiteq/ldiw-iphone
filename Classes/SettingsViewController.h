//
//  SettingsViewController.h
//  Do It
//
//  Created by Vytautas on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Do_ItViewController;
@class EditSettingsViewController;
@class LoginViewController;

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    Do_ItViewController *parent;
    IBOutlet UITableView *myTableView;
    EditSettingsViewController *editSettingsViewController;
    LoginViewController *loginViewController;

}

@property (nonatomic, retain) Do_ItViewController *parent;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) EditSettingsViewController *editSettingsViewController;
@property (nonatomic, retain) LoginViewController *loginViewController;

- (void)backButtonPressed;

@end
