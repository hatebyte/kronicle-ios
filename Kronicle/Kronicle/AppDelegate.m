//
//  AppDelegate.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AppDelegate.h"
#import "ManagedContextController.h"
#import "Kronicle+JSON.h"
#import "KRHomeViewController.h"
#import "KRNavigationViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication
      sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *kropsArray = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"defaultimages"];
    for (NSString *imagepath in kropsArray) {
        NSString *imageSavePath = [documentsDirectory stringByAppendingPathComponent:imagepath];
        if ([fileManager fileExistsAtPath:imageSavePath] == NO) {
            NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:imagepath]);
            [imageData writeToFile:imageSavePath atomically:YES];
        }
    }
    
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
    
    [[ManagedContextController current] saveContext];

    [self preload];
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

- (void)preload {
   
    if (![[ManagedContextController current] hasPreloaded]) {
        NSDictionary *brusselSprouts = @{
                            @"_id" : @"brussel_sprouts"
                            ,@"title" : @"Easy Brussels Sprouts"
                            ,@"description" : @"Despite their bad rap, Brussels sprouts are   incredibly tasty and a great source of vitamins. Here is how I make mine at least twice a week"
                            ,@"category" : @"food"
                            ,@"imageUrl" : @"brussel-sprouts-cover.png"
                            ,@"steps" : @[
                                  @{
                                      @"_id" : @"brussel_sprouts_0"
                                      ,@"title" : @"1.Prep Brussels Sprouts "
                                      ,@"description" : @"Wash in water. Cut off the rough end then half them."
                                      ,@"category" : @"food"
                                      ,@"imageUrl" : @"brussel-sprouts-vid-part-1.mov"
                                      ,@"time" : @120
                                      ,@"indexInKronicle" : @0
                                      }
                                  ,@{
                                      @"_id" : @"brussel_sprouts_1"
                                      ,@"title" : @"2.Prep your garlic"
                                      ,@"description" : @"Peel the garlic by hitting the palm of your hand on a flat side of a chefs knife. Then chop up the garlic. Don't dice them to small or they will burn."
                                      ,@"category" : @"food"
                                      ,@"imageUrl" : @"brussel-sprouts-vid-part-2.mov"
                                      ,@"time" : @120
                                      ,@"indexInKronicle" : @1
                                      }
                                  ,@{
                                      @"_id" : @"brussel_sprouts_2"
                                      ,@"title" : @"3.Heat Your Pan"
                                      ,@"description" : @"Turn the burner to medium heat. "
                                      ,@"category" : @"food"
                                      ,@"imageUrl" : @"brussel-sprouts-vid-part-3.mov"
                                      ,@"time" : @120
                                      ,@"indexInKronicle" : @2
                                      }
                                  ,@{
                                      @"_id" : @"brussel_sprouts_3"
                                      ,@"title" : @"4.Add Half The Butter"
                                      ,@"description" : @"Add 1 tablespoon of butter."
                                      ,@"category" : @"food"
                                      ,@"imageUrl" : @"brussel-sprouts-vid-part-4.mov"
                                      ,@"time" : @30
                                      ,@"indexInKronicle" : @3
                                      }
                                  ,@{
                                      @"_id" : @"brussel_sprouts_4"
                                      ,@"title" : @"5.Add The Brussels Sprouts"
                                      ,@"description" : @"Put them face down on the pan and push them around periodically so they don't stick."
                                      ,@"category" : @"food"
                                      ,@"imageUrl" : @"brussel-sprouts-vid-part-5.mov"
                                      ,@"time" : @400
                                      ,@"indexInKronicle" : @4
                                      }
                                  ,@{
                                      @"_id" : @"brussel_sprouts_5"
                                      ,@"title" : @"6. Butter and Spice"
                                      ,@"description" : @"Now add the rest of the butter and the garlic. You can add salt and pepper if you want."
                                      ,@"category" : @"food"
                                      ,@"imageUrl" : @"brussel-sprouts-vid-part-6.mov"
                                      ,@"time" : @60
                                      ,@"indexInKronicle" : @5
                                      }
                                  
                                  
                                    ]
                            ,@"items" : @[
                                    @"1/2 pound brussels sprouts"
                                    ,@"2 big garlic cloves"
                                    ,@"2 tablespoons salted butter"
                                    ,@"1 tablespoon olive oil"
                                    ,@"Salt"
                                    ,@"Pepper"
                                    ,@"Hot pepper flakes if you want spice"
                                    ]
                            };
        
       
        [Kronicle readFromJSONDictionary:brusselSprouts];
        [[ManagedContextController current] saveContext];
        
    }

}

@end
