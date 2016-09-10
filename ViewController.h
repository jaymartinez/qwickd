//
//  ViewController.h
//  Qwickd
//
//  Created by Jay on 10/14/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "LandingPageViewController.h"
#import "CoreDataHelper.h"
//#import "User.h"
#import "Settings.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate>
{
    IBOutlet UIButton *facebookLoginButton;
    IBOutlet UIButton *twitterLoginButton;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *signUpButton;
    IBOutlet UIImageView *imageView;
}

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;

- (IBAction)facebookLoginButtonTouched:(id)sender;
- (IBAction)twitterLoginButtonTouched:(id)sender;
- (IBAction)loginButtonTouched:(id)sender;
- (IBAction)signUpButtonTouched:(id)sender;

@end
