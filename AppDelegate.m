//
//  AppDelegate.m
//  Qwickd
//
//  Created by Jay on 10/14/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TimerHandler.h"

@implementation AppDelegate

@synthesize fbSession = _session;
@synthesize viewController = _viewController;
@synthesize loginViewController = _loginViewController;
@synthesize window = _window;
@synthesize timerHandler;
@synthesize coreDataHelper = _coreDataHelper;
@synthesize locationHelper = _locationHelper;


- (CoreDataHelper *)coreDataHelper {
    if (_coreDataHelper != nil) {
        return _coreDataHelper;
    }
    
    _coreDataHelper = [[CoreDataHelper alloc] init];
    return _coreDataHelper;
}

- (LocationHelper *)locationHelper {
    if (_locationHelper != nil) {
        return _locationHelper;
    }
    
    _locationHelper = [[LocationHelper alloc] init];
    return _locationHelper;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Add notification and start our timer
    /***** TURN OFF TIMER STUFF FOR NOW *****
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(turnOnLocationService)
                                                name:TIMER_NOTIFICATION
                                              object:nil];
    
    timerHandler = [[TimerHandler alloc] initWithTimeInterval:TEN_MINUTE_INTERVAL];
    */
    //NSLog(@"Timer started");
    //[timerHandler startRepeatingTimer:self];
    
    //Get user's location
    [self turnOnLocationService];
    
    
    // Add our Parse app id
    [Parse setApplicationId:@"dMgZHfcgN57l3FiHoKzrFO1nGFQ5sHp5bNXBkwnz"
                  clientKey:@"gUctXmFiAnZ7JKp59ieTlNKRQVM7AId3esu9U90F"];
    
    //Facebook initialization
    [PFFacebookUtils initializeFacebook];
    
    //Twitter init
    [PFTwitterUtils initializeWithConsumerKey:@"1MTQE2i3Y6dbiDgIzek6A"
                               consumerSecret:@"RdLM0ar32hMBfkOBI467RHDsGdT44h2CYMJeik1F4TQ"];
    
    //Save default data
    //If there is no search radius then set one here
//    NSArray *lSettingsData = [self.coreDataHelper fetchData:SETTINGS_ENTITY];
//    if (lSettingsData.count == 0) {
//        [self.coreDataHelper saveSearchRadius:4000.0];
//    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone"
                                                           bundle:nil];
    
    self.viewController.title = @"Qwickd";
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = navc;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)turnOnLocationService {
    [self.locationHelper turnOnLocationService];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state.
    //This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
    //or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    /*
    LandingPageViewController *lvc = [[LandingPageViewController alloc] init];
    [lvc.locationManager stopUpdatingLocation];
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //invalidate our timer
    /*
    if ([self.timerHandler repeatingTimer] != nil)
        [self.timerHandler stopRepeatingTimer:self];
     */
    
    //stop location service
    [self.locationHelper.locationManager stopUpdatingLocation];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    /*
    if ([self.timerHandler repeatingTimer] == nil)
        [self.timerHandler startRepeatingTimer:self];
     */
    
    [self turnOnLocationService];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActiveWithSession:self.fbSession];
    /*
    LandingPageViewController *lvc = [[LandingPageViewController alloc] init];
    [lvc.locationManager startUpdatingLocation];
     */
    
    /***Turn off timer for now *****/
    //if ([PFUser currentUser] && [self.timerHandler repeatingTimer] == nil) {
      //  [self.timerHandler startRepeatingTimer:self];
    //}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.fbSession close];
    
    //TODO: call to CoreDataHelper
    [self.coreDataHelper saveContext];
    
    /*
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TIMER_NOTIFICATION
                                                  object:nil];
     */
}

@end
