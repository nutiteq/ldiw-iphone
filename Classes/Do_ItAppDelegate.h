//
//  Do_ItAppDelegate.h
//  Do It
//
//  Created by Vytautas on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Do_ItAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	NSDictionary *settings;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSDictionary *settings;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
           
@end

