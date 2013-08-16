//
//  AppDelegate.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AppDelegate.h"

#import "KRHomeViewController.h"
#import <CocoaLumberjack/DDTTYLogger.h>
#import "KRNavigationViewController.h"

static const int ddLogLevel = LOG_LEVEL_INFO;


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
//    KRHomeViewController *viewController = [[KRHomeViewController alloc] initWithNibName:@"KRHomeViewController" bundle:nil];
    KRHomeViewController *viewController = [KRHomeViewController current];
    
    KRNavigationViewController *navigationController = [[KRNavigationViewController alloc] initWithRootViewController:viewController];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

//    [DDLog addLogger:[DDTTYLogger sharedInstance]];
//    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
//    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]
//                                     backgroundColor:[UIColor redColor]
//                                             forFlag:LOG_FLAG_ERROR];
//    
//    DDLogError(@"Paper jam");                              // Red
//    DDLogWarn(@"Toner is low");                            // Orange
//    DDLogInfo(@"Warming up printer (pre-customization)");  // Default (black)
//    DDLogVerbose(@"Intializing protcol x26");              // Default (black)
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
