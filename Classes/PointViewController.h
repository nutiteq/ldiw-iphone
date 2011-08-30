//
//  PointViewController.h
//  Do It
//
//  Created by Vytautas on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Do_ItAppDelegate.h"

@class Do_ItViewController;

@interface PointViewController : UIViewController  <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    NSString *fullSource;
    IBOutlet UIView *loadingBackground;
    IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView; 
@property (nonatomic, retain) NSString *fullSource;
@property (nonatomic, retain) IBOutlet UIView *loadingBackground;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;

- (void)backButtonPressed;

@end
