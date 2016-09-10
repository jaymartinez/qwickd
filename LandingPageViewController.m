//
//  LandingPageViewController.m
//  Qwickd
//
//  Created by Jay on 10/21/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import "LandingPageViewController.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "TimerHandler.h"
#import "LocationData.h"

@interface LandingPageViewController ()

@end

@implementation LandingPageViewController

@synthesize welcomeLabel;
@synthesize mSettings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        locationHelper = [[LocationHelper alloc] init];
        coreDataHelper = [[CoreDataHelper alloc] init];
        placesHelper = [[PlacesHelper alloc] init];
        placesInformation = [[PlacesInformation alloc] init];
        [self.view setBackgroundColor:[UIColor lightGrayColor]];
        
        /* Tool Bar Items */
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:self
                                                                                action:nil];
        
        UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"53-house.png"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(go_home:)];
        [homeButtonItem setTag:kHomeButton];
        
        UIBarButtonItem *nearbyButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nearby-icon.png"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(nearbyButton_click:)];
        [nearbyButtonItem setTag:kNearbyButton];
        
        UIBarButtonItem *gearButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"20-gear-2.png"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(settings_click:)];
        [gearButtonItem setTag:kSettingsButton];
        
        UIBarButtonItem *bubbleButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"286-speechbubble.png"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
        [bubbleButtonItem setTag:kChatButton];
        
        [homeButtonItem setTintColor:[UIColor darkGrayColor]];
        [gearButtonItem setTintColor:[UIColor darkGrayColor]];
        [nearbyButtonItem setTintColor:[UIColor darkGrayColor]];
        [bubbleButtonItem setTintColor:[UIColor darkGrayColor]];
        self.toolbarItems = myToolbarItems = [[NSArray alloc] initWithObjects:spacer,homeButtonItem,spacer,gearButtonItem,spacer,nearbyButtonItem,spacer,bubbleButtonItem,spacer, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.navigationController setToolbarItems:myToolbarItems];
    
    //[self setToolbarItems:toolbarItems];
    
    
}

- (IBAction)go_home:(id)sender
{
    ViewController *vc = [self.navigationController.viewControllers objectAtIndex:0];
    [self.navigationController popToViewController:vc
                                          animated:NO];
}

- (void)fetchPlaces_callback:(PlacesInformation *)pPlacesInformation
{
    //save place information to core data
    [coreDataHelper deleteManagedObject:PLACES_ENTITY];
    [coreDataHelper deleteManagedObject:PLACE_DETAILS_ENTITY];
    
    //save to core data
    [coreDataHelper savePlacesData:pPlacesInformation];
    
    NearbyViewController *nvc = [[NearbyViewController alloc] init];
    [nvc setToolbarItems:myToolbarItems];
    [self.navigationController pushViewController:nvc
                                         animated:NO];
    
    [[activityView activityIndicator] stopAnimating];
    [activityView removeFromSuperview];
}

- (void)updatePlaces
{
    //Create serial dispatch queue
    //dispatch_queue_t queue;
    //queue = dispatch_queue_create(DISPATCH_QUEUE_1, NULL);
    //if (queue) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //dispatch_async(queue, ^{
            
            //start our activity indicator
            [self.navigationController.view addSubview:activityView];
                    
            //Do our main places web service call
            //placesInformation = [locationHelper fetchPlaces];
            placesInformation = [placesHelper fetchPlaces];
            [self performSelectorOnMainThread:@selector(fetchPlaces_callback:)
                                   withObject:placesInformation
                                waitUntilDone:YES];
        });
    //}
}

- (IBAction)nearbyButton_click:(id)sender
{
    
    activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    //UILabel *messageLabel = [[UILabel alloc] init];
    //[messageLabel setText:@"Updating place list, please wait..."];
    //[activityView setLabel:messageLabel];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    [self.navigationController.view addSubview:activityView];
    
    
    NSArray *placeData = [coreDataHelper fetchData:PLACES_ENTITY];
    if (placeData != nil && placeData.count > 0) {
        PlacesData *lRecentPlace = [placeData objectAtIndex:[placeData count] - 1];
        NSDate *recordedAt = [lRecentPlace recordedAt];
        NSTimeInterval elapsed = [recordedAt timeIntervalSinceDate:[NSDate date]];
        NSLog(@"Elapsed: %f", elapsed);
        //if date recorded is older than ten minutes
        if (elapsed < -600) {
            [self updatePlaces];
        }
        else {
            NearbyViewController *nvc = [[NearbyViewController alloc] init];
            [nvc setToolbarItems:myToolbarItems];
            [self.navigationController pushViewController:nvc
                                                 animated:NO];
            [activityView.activityIndicator stopAnimating];
            [activityView removeFromSuperview];
        }
    }
    else {
        [self updatePlaces];
    }
}

- (IBAction)settings_click:(id)sender
{
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    [svc setTitle:@"Settings"];
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:NO];
    
    PFUser *lCurrentUser = [PFUser currentUser];
    
    [self.navigationController setTitle:@"Qwickd"];
    
    BOOL isLinked = [PFFacebookUtils isLinkedWithUser:lCurrentUser];
    NSLog(@"is facebook linked = %u",isLinked);
    BOOL isTwitterLinked = [PFTwitterUtils isLinkedWithUser:lCurrentUser];
    NSLog(@"is Twitter linked = %u", isTwitterLinked);
    
    if (lCurrentUser && [PFFacebookUtils isLinkedWithUser:lCurrentUser]) {
        [welcomeLabel setText:@"Logged in through Facebook"];
    }
    else if (lCurrentUser && [PFTwitterUtils isLinkedWithUser:lCurrentUser]) {
        [welcomeLabel setText:@"Logged in through Twitter"];
    }
    else {
        if (lCurrentUser) {
            NSString *firstName = lCurrentUser[@"FirstName"];
            if (firstName != nil && firstName.length > 0) {
                NSString *welcomeMessage = @"Welcome, ";
                welcomeMessage = [welcomeMessage stringByAppendingString:firstName];
                welcomeMessage = [welcomeMessage stringByAppendingString:@"!"];
                [welcomeLabel setText:welcomeMessage];
            }
            else {
                [welcomeLabel setText:@""];
            }
        }
        else {
            [welcomeLabel setText:@""];
        }
    }
    
    /*
    UIImage *settingsImage = [UIImage imageNamed:@"settings-icon24px.png"];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:settingsImage
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(settings_click:)];
    [[self navigationItem] setRightBarButtonItem:settingsButton];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(go_home:)];
    [[self navigationItem] setLeftBarButtonItem:homeButton];
    */
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
