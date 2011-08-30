//
//  EditSettingsViewController.h
//  Do It
//
//  Created by Vytautas on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Do_ItViewController;

@interface EditSettingsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIPickerView *pickerView;
    IBOutlet UITableView *myTableView;
    IBOutlet UIView *myPickerView;
    Do_ItViewController *parent;
    NSString *showView;
    NSMutableArray *pickerNumerbers;
}

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIView *myPickerView;
@property (nonatomic, retain) Do_ItViewController *parent;
@property (nonatomic, retain) NSString *showView;
@property (nonatomic, retain) NSMutableArray *pickerNumbers;

- (void)setSetting;
- (void)backButtonPressed;

@end
