//
//  ALAppDelegate.m
//  Notes
//
//  Created by Artem Shiyanov on 04.07.13.
//  Copyright (c) 2013 AS. All rights reserved.
//

#import "AppDelegate.h"
#import "AppLiftAccess.h"
#import "APTLoginVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	APTLoginVC *loginVC = [[APTLoginVC alloc] initWithNibName:@"APTLoginVC"
													   bundle:nil];
	UINavigationController * navController = [[UINavigationController alloc] initWithNavigationBarClass:nil toolbarClass:nil];
	navController.viewControllers = @[loginVC];
	self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillTerminate:(UIApplication *)anApplication
{
    NSError *error = NULL;
    if ([[AppLiftAccess sharedAccess] managedObjectContext] != nil)
	{
        if ([[[AppLiftAccess sharedAccess] managedObjectContext] hasChanges] &&
			![[[AppLiftAccess sharedAccess] managedObjectContext] save:&error])
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#if DEBUG
			abort();
#endif
		}
    }
}

- (NSUInteger)application:(UIApplication *)application
supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
