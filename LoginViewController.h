//
//  LoginViewController.h
//  Qwickd
//
//  Created by Jay on 10/21/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
//#import "User.h"
#import "LandingPageViewController.h"
#import "SignUpViewController.h"
#import "ViewController.h"
#import "Settings.h"

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIView *loginView;
}

@property (nonatomic, retain) Settings *mSettings;

- (IBAction)loginButton_click:(id)sender;
- (IBAction)cancelButton_click:(id)sender;
- (IBAction)signUpButton_click:(id)sender;


@end
