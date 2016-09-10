//
//  DefaultSurveyViewController.m
//  Qwickd
//
//  Created by Jay on 1/23/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "DefaultSurveyViewController.h"
#import "AppDelegate.h"
#import "LocationData.h"
#import "PlaceDetails.h"
#import "PlacesData.h"
#import "CoreDataHelper.h"
#import "SBJsonParser.h"
#import "PlaceDetailsView.h"

@interface DefaultSurveyViewController ()

@end

@implementation DefaultSurveyViewController

@synthesize coreDataHelper;
@synthesize currentPlace;
@synthesize placeId;
@synthesize placesInformation;
@synthesize myToolbarItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        coreDataHelper = [[CoreDataHelper alloc] init];
        self.placesInformation = [[PlacesInformation alloc] init];
        [self.view setBackgroundColor:[UIColor lightTextColor]];
        self.toolbarItems = [[NSArray alloc] init];
        //self.placeId = [[NSString alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    PlacesInformation *lPlacesInformation = self.placesInformation;
    detailsView = [[PlaceDetailsView alloc] initWithFrame:CGRectMake(0.0f, 70.0f, self.view.frame.size.width, 200.0f)];
    [[detailsView addressLabel] setText:[lPlacesInformation placeAddress]];
    [[detailsView placeName] setText:[lPlacesInformation placeName]];
    //[[detailsView phoneNumberLabel] setText:[lPlacesInformation phoneNumber]];
    [[detailsView phoneNumberTextView] setText:[lPlacesInformation phoneNumber]];
    //[[detailsView websiteLabel] setText:[lPlacesInformation websiteUrl]];
    [[detailsView websiteTextView] setText:[lPlacesInformation websiteUrl]];
    [self.view addSubview:detailsView];
    
    //survey view
    surveyView = [[SurveyView alloc] initWithFrame:CGRectMake(0.0f, 200.0f, self.view.frame.size.width, 180.0f)];
    [[surveyView commentsTextField] setDelegate:self];
    [self.view addSubview:surveyView];
    
    //submit button
    CGFloat lButtonWidth = self.view.frame.size.width/2;
    CGFloat lButtonXPos = self.view.frame.size.width/4;
    CGFloat lViewHeight = self.view.frame.size.height;
    CGFloat lButtonHeight = 40.0f;
    CGFloat lToolBarHeight = self.navigationController.toolbar.frame.size.height;
    CGFloat lButtonYPos = lViewHeight - lToolBarHeight - lButtonHeight - 30;
    submitButton = [[UIButton alloc] initWithFrame:CGRectMake(lButtonXPos, lButtonYPos, lButtonWidth, 40)];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton setBackgroundColor:[UIColor whiteColor]];
    [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitButton.layer setCornerRadius:10.0f];
    [submitButton addTarget:self
                     action:@selector(submit:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)submit:(id)sender
{
    NSString *goodExp = [[surveyView goodExpButton] selectedSegmentIndex] == 0 ? @"Yes" : @"No";
    NSString *recommend = [[surveyView recommendButton] selectedSegmentIndex] == 0 ? @"Yes" : @"No";
    NSString *placeClean = [[surveyView placeCleanButton] selectedSegmentIndex] == 0 ? @"Yes" : @"No";
    NSString *comments = [[surveyView commentsTextField] text];
    PFObject *placesObject = [PFObject objectWithClassName:DEFAULT_SURVEY_ENTITY];
    placesObject[@"user"] = [PFUser currentUser];
    placesObject[@"recommendYN"] = recommend;
    placesObject[@"goodExperienceYN"] = goodExp;
    placesObject[@"placeCleanYN"] = placeClean;
    placesObject[@"place"] = self.placesInformation.placeName;
    placesObject[@"comments"] = comments;
    placesObject[@"placeId"] = self.placesInformation.placeId;
    
    [placesObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Survey Complete"
                                                            message:@"Thanks for taking the survey!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
}

- (void)slideContainerUp
{
    [UIView animateWithDuration:0.35
                     animations:^{
                         [surveyView setFrame:CGRectMake(0, 50, self.view.frame.size.width, 180.0f)];
                         
                     }
                     completion:^(BOOL finished){
                         containerIsUp = true;
                         [[surveyView goodExpButton] setHidden:YES];
                         [[surveyView placeCleanButton] setHidden:YES];
                         [[surveyView recommendButton] setHidden:YES];
                         [[surveyView question1Label] setHidden:YES];
                         [[surveyView question2Label] setHidden:YES];
                         [[surveyView question3Label] setHidden:YES];
                     }];
    
}

- (void)slideContainerDown
{
    [UIView animateWithDuration:0.35
                     animations:^{
                         [surveyView setFrame:CGRectMake(0.0f, 200.0f, self.view.frame.size.width, 180.0f)];
                         [[surveyView goodExpButton] setHidden:NO];
                         [[surveyView placeCleanButton] setHidden:NO];
                         [[surveyView recommendButton] setHidden:NO];
                         [[surveyView question1Label] setHidden:NO];
                         [[surveyView question2Label] setHidden:NO];
                         [[surveyView question3Label] setHidden:NO];
                     }
                     completion:^(BOOL finished){
                         containerIsUp = false;
                     }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (containerIsUp == false) {
        [self slideContainerUp];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self slideContainerDown];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
