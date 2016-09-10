//
//  ViewController.m
//  Qwickd
//
//  Created by Jay on 10/14/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import "ViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "LandingPageViewController.h"
#import "AppDelegate.h"
#import "LocationData.h"
#import "LoginView.h"

@interface ViewController () <FBLoginViewDelegate>

@end

@implementation ViewController

//@synthesize lUser;
@synthesize activityIndicator;
@synthesize coreDataHelper = _coreDataHelper;

- (id)init
{
    self = [super init];
    if (self)
    {
        imageView = [[UIImageView alloc] init];
    }
    
    return self;
}

- (CoreDataHelper *)coreDataHelper {
    if (_coreDataHelper != nil) {
        return _coreDataHelper;
    }
    
    _coreDataHelper = [[CoreDataHelper alloc] init];
    return _coreDataHelper;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        LandingPageViewController *lvc = [[LandingPageViewController alloc] init];
        [lvc setTitle:@"Qwickd"];
        [self.navigationController pushViewController:lvc
                                             animated:NO];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:YES];
    /**** TESTING PURPOSES ******/
//    NSError *error;
//    NSManagedObjectContext *context = [self.coreDataHelper context];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    
//    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:LOCATION_ENTITY
//                                                      inManagedObjectContext:context];
//    [fetchRequest setEntity:locationEntity];
//    NSArray *lResults = [context executeFetchRequest:fetchRequest
//                                               error:&error];
//    if (lResults != nil && lResults.count > 0) {
//        NSLog(@"num Location records: %lu", (unsigned long)lResults.count);
//        for (LocationData *data in lResults) {
//            double lCurLat = [[data latitude] doubleValue];
//            double lCurLong = [[data longitude] doubleValue];
//            double lLastLat = [[data lastLatitude] doubleValue];
//            double lLastLong = [[data lastLongitude] doubleValue];
//            NSLog(@"Cur lat: %f", lCurLat);
//            NSLog(@"Cur Long: %f", lCurLong);
//            NSLog(@"Last Lat: %f", lLastLat);
//            NSLog(@"Last Long: %f", lLastLong);
//        }
//    }
    /***************END*****************
    ********************************/
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [loginButton setTitle:@"Log Out"
                     forState:UIControlStateNormal];
        [signUpButton setTitle:@"Main"
                      forState:UIControlStateNormal];
    }
    else {
        [loginButton setTitle:@"Log In"
                     forState:UIControlStateNormal];
        [signUpButton setTitle:@"Sign Up"
                      forState:UIControlStateNormal];
    }
}

- (void)unlink_fbUser
{
    PFUser *currentUser = [PFUser currentUser];
    [PFFacebookUtils unlinkUserInBackground:currentUser block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"The user is no longer associated with their Facebook account");
        }
    }];
}



- (IBAction)twitterLoginButtonTouched:(id)sender
{
    LandingPageViewController *vc = [[LandingPageViewController alloc] init];
    
    //Start the activity indicator
    ActivityView *lActivityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    [lActivityView.activityIndicator startAnimating];
    [lActivityView layoutSubviews];
    [self.view addSubview:lActivityView];
    
    if ([PFUser currentUser] &&
        [PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self.navigationController pushViewController:vc
                                             animated:NO];
    }
    else {
        [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
            if (!user) {
                if (!error) {
                    NSLog(@"Some error happened");
                }
                else {
                    NSLog(@"The user cancelled the Twitter login.");
                }
                [lActivityView.activityIndicator stopAnimating];
                [lActivityView removeFromSuperview];
                return;
            }
            if (user.isNew) {
                NSLog(@"User signed up and logged in with Twitter!");
            }
            else {
                NSLog(@"User logged in with Twitter!");
            }
            [PFTwitterUtils linkUser:user block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [vc setTitle:@"Qwickd"];
                    [self.navigationController pushViewController:vc
                                                         animated:NO];
                    [lActivityView.activityIndicator stopAnimating];
                    [lActivityView removeFromSuperview];
                }
            }];
        }];
    }
    
}

- (IBAction)facebookLoginButtonTouched:(id)sender
{
    //VC to push
    LandingPageViewController *lpvc = [[LandingPageViewController alloc] init];
    [lpvc setTitle:@"Qwickd"];
    
    //Start the activity indicator
    ActivityView *lActivityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    [lActivityView.activityIndicator startAnimating];
    [lActivityView layoutSubviews];
    [self.view addSubview:lActivityView];
    
    if ([PFUser currentUser] &&
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self.navigationController pushViewController:lpvc
                                             animated:NO];
    }
    else {
        
        // set up the FB permissions
        NSArray *permissions = @[@"user_about_me", @"user_location"];
        
        // login with permissions
        [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
            if (!user) {
                if (!error) {
                    NSLog(@"Some error occurred");
                }
                else {
                    NSLog(@"The user cancelled the Facebook login");
                }
                [lActivityView.activityIndicator stopAnimating];
                [lActivityView removeFromSuperview];
                return;
            }
            [PFFacebookUtils linkUser:user permissions:permissions
                                block:^(BOOL succeeded, NSError *error) {
                                    if (succeeded) {
                                        [self.navigationController pushViewController:lpvc
                                                                             animated:NO];
                                        //Stop the activity indicator
                                        [lActivityView.activityIndicator stopAnimating];
                                        [lActivityView removeFromSuperview];
                                    }
                                }];
        }];
    }
}

- (IBAction)loginButtonTouched:(id)sender
{
    //If user is already logged in, this button will serve as the logout button.
    if ([PFUser currentUser]) {
        [PFUser logOut];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                         message:@"You are now logged out"
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil, nil];
        [alert show];
        [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
        [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        [facebookLoginButton setHidden:NO];
        [signUpButton setHidden:NO];
    }
    else {
//        CGRect frame = [[UIScreen mainScreen] applicationFrame];
//        frame.origin.y = frame.size.height/8;
//        
//        LoginView *loginView = [[LoginView alloc] initWithFrame:frame];
//        [self.view addSubview:loginView];
        
        LoginViewController *lvc = [[LoginViewController alloc] init];
        lvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [lvc setTitle:@"Login"];
//        [self.navigationController presentViewController:lvc
//                                                animated:YES
//                                              completion:NULL];
        
        [self.navigationController pushViewController:lvc
                                             animated:NO];
        
    }
}

- (IBAction)signUpButtonTouched:(id)sender
{
    // If the user is logged in, go directly to landing page.
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        LandingPageViewController *lvc = [[LandingPageViewController alloc] init];
        [self.navigationController pushViewController:lvc
                                             animated:NO];
    }
    else {
        SignUpViewController *vc = [[SignUpViewController alloc] init];
        [vc setTitle:@"Register"];
        [self.navigationController pushViewController:vc
                                             animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
