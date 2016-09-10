//
//  SignUpViewController.h
//  Qwickd
//
//  Created by Jay on 10/21/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
//#import "User.h"
#import "LoginViewController.h"
#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import "Settings.h"

@interface SignUpViewController : UIViewController
{
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *signUpButton;
    IBOutlet UITextField *firstNameField;
    IBOutlet UITextField *lastNameField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField1;
    IBOutlet UITextField *passwordField2;
}

@property (nonatomic, retain) Settings *mSettings;
//@property (nonatomic, retain) User *lUser;
@property (nonatomic, retain) IBOutlet UIButton *signUpButton;

- (IBAction)loginButton_click:(id)sender;
- (IBAction)cancelButton_click:(id)sender;
- (IBAction)signUpButton_click:(id)sender;

- (void)inputChanged:(NSNotification *)note;

@end
