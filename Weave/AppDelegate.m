//
//  AppDelegate.m
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "AppDelegate.h"
#import "Likes.h"
#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"

//#define MIXPANEL_TOKEN @"631695be4a64754e91c244f279c83246"
//#define FLURRY_TOKEN @"ZP7ZN8QR3Q3SDPZGK5K6"
#define FLURRY_TOKEN @""
#define MIXPANEL_TOKEN @""


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Initialize the library with your
    // Mixpanel project token, MIXPANEL_TOKEN
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:FLURRY_TOKEN];
    
    UAConfig *config = [UAConfig defaultConfig];
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];

    
    return YES;
}


+ (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
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
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    
    NSLog(@"Closing app...");
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"App Closed" properties:@{@"datestring": dateString}];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [FBAppEvents activateApp];
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
   
   // [mixpanel.people increment:@"played" by:[NSNumber numberWithInt:1]];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"Opened App %@", dateString);
    
    [mixpanel track:@"App Opened" properties:@{@"timestamp": dateString}];
    [mixpanel.people increment:@"played" by:[NSNumber numberWithInt:1]];
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

     
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.session close];
}

@end
