//
//  KMAppDelegate.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMAppDelegate.h"
#import "KMStoryBoardUtilities.h"
#import "KMDiscoverListViewController.h"
#import "SWHTTpTrafficRecorder.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "OHHTTPStubs/OHHTTPStubs+Mocktail.h"

@implementation KMAppDelegate

#pragma mark -
#pragma mark Application

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UINavigationController* navigationController = (UINavigationController*)[KMStoryBoardUtilities viewControllerForStoryboardName:@"KMDiscoverStoryboard" class:[KMDiscoverListViewController class]];
    
    [self.window setRootViewController:navigationController];
    
    [self setupNavigationTitleLabelStyle];
    [self setupStatusBarStyle];
    
    
    //TODO add argument for recording
    
    [SWHttpTrafficRecorder sharedRecorder].recordingFormat = SWHTTPTrafficRecordingFormatMocktail ;
    NSError *error ;
    [[SWHttpTrafficRecorder sharedRecorder] startRecordingAtPath:@"/Users/bastien/Desktop/moktails" error:&error];

    
    
    NSString *stubArg = @"Appsnap_stubbing";
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF matches[c] %@", stubArg];
    BOOL stubbing = [[NSProcessInfo processInfo].arguments filteredArrayUsingPredicate:p].count > 0 ;

    if (stubbing) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"appsnap" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        
        NSError *error;
        [OHHTTPStubs stubRequestsUsingMocktailsAtPath:@"mocktails" inBundle:bundle error:&error];
        [OHHTTPStubs onStubActivation:^(NSURLRequest * _Nonnull request, id<OHHTTPStubsDescriptor>  _Nonnull stub, OHHTTPStubsResponse * _Nonnull responseStub) {
            NSLog(@"[stub] %@",request.URL.absoluteString);
        }];
    }
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -
#pragma mark App Style Setup Methods

- (void)setupNavigationTitleLabelStyle
{
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:@"GillSans-Light" size:20] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)setupStatusBarStyle
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark -
#pragma mark UIApplicationDelegate Methods

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
