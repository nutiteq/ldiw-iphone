//
//  Do_ItAppDelegate.m
//  Do It
//
//  Created by Vytautas on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Do_ItAppDelegate.h"
#import "Do_ItViewController.h"
#import "FlurryAPI.h"

@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx 
{
	if([self isMemberOfClass:[UINavigationBar class]])
	{
		UIImage *image = [UIImage imageNamed:@"head.png"];
		CGContextClip(ctx);
		CGContextTranslateCTM(ctx, 0, image.size.height);
		CGContextScaleCTM(ctx, 1.0, -1.0);
		CGContextDrawImage(ctx,
						   CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), image.CGImage); 
	}
	else 
	{        
		[super drawLayer:layer inContext:ctx];     
	}
}  

@end


@implementation Do_ItAppDelegate

@synthesize window, settings, navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
    [FlurryAPI startSession:@"18W7IK7YRL1FHZVKE6WM"];
    
    // Override point for customization after application launch.
	NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"Settings.plist"];
    self.settings = [NSDictionary dictionaryWithContentsOfFile:finalPath];
	
    // Add the view controller's view to the window and display.
	[self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc 
{
    [window release];
	[settings release];
	[navigationController release];
    
    [super dealloc];
}


@end
