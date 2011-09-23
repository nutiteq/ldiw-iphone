//
//  LoginViewController.h
//  Do It
//
//  Created by Vytautas on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Do_ItViewController;
@class Do_ItAppDelegate;
@class LoginViewController;

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIImageView *imageView;
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *passwordTextField;
    Do_ItViewController *parent;
    Do_ItAppDelegate *appDelegate;
    IBOutlet UIView *loadingBackground;
    IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) Do_ItViewController *parent;
@property (nonatomic, retain) Do_ItAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UIView *loadingBackground;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;

- (void)backButtonPressed;
- (void)okButtonPressed;

@end
