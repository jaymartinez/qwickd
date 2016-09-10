//
//  SettingsViewController.h
//  Qwickd
//
//  Created by Jay on 12/1/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Settings.h"
#import "QWLocation.h"
#import "CoreDataHelper.h"
#import "SettingsData.h"

@interface SettingsViewController : UIViewController
{
    IBOutlet UITextField *radiusTextField;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *unlinkFacebookButton;
    IBOutlet UIButton *unlinkTwitterButton;
    IBOutlet UIButton *logoutButton;
    
    double searchRadius;
}

@property (nonatomic) Settings *mSettings;
@property (nonatomic) QWLocation *qwLocation;
@property (nonatomic) CoreDataHelper *coreDataHelper;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;
@property (nonatomic) SettingsData *settingsData;
@property (nonatomic) NSArray *myToolbarItems;

- (IBAction)logoutButton_click:(id)sender;
- (IBAction)unlinkFacebookButton_click:(id)sender;
- (IBAction)unlinkTwitterButton_click:(id)sender;
- (IBAction)saveButton_click:(id)sender;

@end
