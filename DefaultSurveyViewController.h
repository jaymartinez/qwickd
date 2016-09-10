//
//  DefaultSurveyViewController.h
//  Qwickd
//
//  Created by Jay on 1/23/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "PlaceDetailsView.h"
#import "PlacesInformation.h"
#import "SurveyView.h"

@interface DefaultSurveyViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UISegmentedControl *expSegment;
    IBOutlet UISegmentedControl *cleanSegment;
    IBOutlet UISegmentedControl *recommendSegment;
    IBOutlet UIButton *submitButton;
    IBOutlet UITextView *commentsTextView;
    PlaceDetailsView *detailsView;
    SurveyView *surveyView;
    
    BOOL containerIsUp;
}

@property (nonatomic, strong) CoreDataHelper *coreDataHelper;
@property (nonatomic, strong) NSString *currentPlace;
@property (nonatomic) NSString *placeId;
@property (nonatomic) PlacesInformation *placesInformation;
@property (nonatomic) NSArray *myToolbarItems;

- (IBAction)submit:(id)sender;

@end
