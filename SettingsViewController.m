//
//  SettingsViewController.m
//  Qwickd
//
//  Created by Jay on 12/1/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "TimerHandler.h"
#import "ActivityView.h"
#import "SettingsData.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize saveButton;
@synthesize mSettings;
@synthesize coreDataHelper;
@synthesize settingsData;
@synthesize myToolbarItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //coreDataHelper = [[CoreDataHelper alloc] init];
        
        //Get the settings data so we can check if there is a radius
//        NSArray *lSettings = [coreDataHelper fetchData:SETTINGS_ENTITY];
//        if (lSettings != nil && lSettings.count > 0) {
//            settingsData = [lSettings objectAtIndex:[lSettings count] - 1];
//        }
//        else {
//            searchRadius = 500.0;
//        }
        self.toolbarItems = [[NSArray alloc] init];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarItems:self.toolbarItems];
    //NSLog(@"View appears: radius = %d", [mSettings getSearchRadius]);
//    double lRadius = 0.0f;
//    if (settingsData == nil || settingsData.searchRadius == nil || settingsData.searchRadius.doubleValue <= 0.0) {
//        lRadius = round(searchRadius);
//    } else {
//        lRadius = round(settingsData.searchRadius.doubleValue);
//    }
//    
//    NSString *lRadiusStr = [[NSString alloc] initWithFormat:@"%.0f", lRadius];
//    [radiusTextField setText:lRadiusStr];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.saveButton.enabled = NO;
    self.saveButton.alpha = 0.7;
}

- (IBAction)logoutButton_click:(id)sender
{
    //default logout
    
    if ([PFUser currentUser]) {
        [PFUser logOut];
        
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                        message:@"You are now logged out"
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil, nil];
         */
        //[alert show];
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)saveButton_click:(id)sender
{
    //save search radius
//    NSString *textValue = radiusTextField.text;
//    
//    NSLog(@"Text Value: %@", textValue);
//    NSError *error;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]+$"
//                                                                           options:NSRegularExpressionAllowCommentsAndWhitespace
//                                                                             error:&error];
    
    //Check for valid matches against the regular expression
//    NSUInteger lMatches = [regex numberOfMatchesInString:textValue
//                                                 options:0
//                                                   range:NSMakeRange(0, [textValue length])];
//    if (lMatches == 0 || textValue.length > 6 || [textValue doubleValue] > 164000) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Value"
//                                                        message:@"Enter a valid value for the search radius"
//                                                       delegate:self
//                                              cancelButtonTitle:@"Dismiss"
//                                              otherButtonTitles:nil, nil];
//        [alert show];
//        
//        [radiusTextField setText:@""];
//    }
//    else {
//        double radiusValue = [radiusTextField.text doubleValue];
//        NSLog(@"Saving Radius to Store: %f", radiusValue);
//        
//        [coreDataHelper saveSearchRadius:radiusValue];
//    }
}

- (IBAction)unlinkFacebookButton_click:(id)sender
{
    //unlink facebook account
    if ([PFUser currentUser]) {
        ActivityView *lActivityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        [lActivityView.activityIndicator startAnimating];
        [lActivityView layoutSubviews];
        [self.view addSubview:lActivityView];
        [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]
                                          block:^(BOOL succeeded, NSError *error) {
                                              if (succeeded) {
                                                  [lActivityView.activityIndicator stopAnimating];
                                                  [lActivityView removeFromSuperview];
                                                  [self.navigationController popToRootViewControllerAnimated:NO];
                                              }
                                          }];
    }
}

- (IBAction)unlinkTwitterButton_click:(id)sender
{
    //unlink twitter account
    if ([PFUser currentUser]) {
        //Start the activity indicator
        ActivityView *lActivityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        [lActivityView.activityIndicator startAnimating];
        [lActivityView layoutSubviews];
        [self.view addSubview:lActivityView];
        [PFTwitterUtils unlinkUserInBackground:[PFUser currentUser]
                                         block:^(BOOL succeeded, NSError *error) {
                                             if (succeeded) {
                                                 [lActivityView.activityIndicator stopAnimating];
                                                 [lActivityView removeFromSuperview];
                                                 [self.navigationController popToRootViewControllerAnimated:NO];
                                             }
                                         }];
    }
}

- (void)radiusChanged:(NSNotification *)note
{
//    BOOL enableSaveButton = NO;
//    self.saveButton.alpha = 0.7;
//    
//    if (radiusTextField.text != nil &&
//        radiusTextField.text.length > 0) {
//        enableSaveButton = YES;
//        self.saveButton.alpha = 1.0;
//    }
//    
//    self.saveButton.enabled = enableSaveButton;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
