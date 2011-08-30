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

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    Do_ItViewController *parent;
    IBOutlet UITableView *myTableView;
    EditSettingsViewController *editSettingsViewController;
}

@property (nonatomic, retain) Do_ItViewController *parent;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) EditSettingsViewController *editSettingsViewController;

- (void)backButtonPressed;

@end
