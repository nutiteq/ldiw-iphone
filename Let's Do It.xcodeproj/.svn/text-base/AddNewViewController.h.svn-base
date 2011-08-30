//
//  AddNewViewController.h
//  Do It
//
//  Created by Vytautas on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Do_ItViewController;
@class Do_ItAppDelegate;
@class TextEditViewController;

@interface AddNewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    Do_ItViewController *parent;
    Do_ItAppDelegate *appDelegate;
    NSMutableArray *fieldsInfo;
    IBOutlet UITableView *myTableView;
//    NSMutableArray *sectionTitles;
    NSMutableDictionary *switches;
    TextEditViewController *textEditViewController;
    NSMutableDictionary *collectedInfo;
    UIImage *photo;
    UIImagePickerController *imagePickerController;
    NSMutableDictionary *collectedData;
    NSString *sessionId;
    NSString *sessionName;
    IBOutlet UIView *loadingBackground;
    IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
}

@property (nonatomic, retain) Do_ItViewController *parent;
@property (nonatomic, retain) Do_ItAppDelegate *appDelegate;
@property (nonatomic, retain) NSMutableArray *fieldsInfo;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
//@property (nonatomic, retain) NSMutableArray *sectionTitles;
@property (nonatomic, retain) NSMutableDictionary *switches;
@property (nonatomic, retain) TextEditViewController *textEditViewController;
@property (nonatomic, retain) NSMutableDictionary *collectedInfo;
@property (nonatomic, retain) UIImage *photo;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) NSMutableDictionary *collectedData;
@property (nonatomic, retain) NSString *sessionId;
@property (nonatomic, retain) NSString *sessionName;
@property (nonatomic, retain) IBOutlet UIView *loadingBackground;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;

- (void)add;
- (void)backButtonPressed;
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;

@end
