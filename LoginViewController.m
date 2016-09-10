//
//  LoginViewController.m
//  Qwickd
//
//  Created by Jay on 10/21/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

//@synthesize lUser;
@synthesize mSettings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //lUser = [[User alloc] init];
        mSettings = [[Settings alloc] init];
        
        //loginView = [[UIView alloc] init];
    }
    return self;
}

- (IBAction)loginButton_click:(id)sender
{
    //Process login
    LandingPageViewController *lvc = [[LandingPageViewController alloc] init];
    NSString *email = [[NSString alloc] initWithString:[emailTextField text]];
    NSString *password = [[NSString alloc] initWithString:[passwordTextField text]];
    
    //Start the activity indicator
    ActivityView *lActivityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    [lActivityView.activityIndicator startAnimating];
    [lActivityView layoutSubviews];
    [self.view addSubview:lActivityView];
    [PFUser logInWithUsernameInBackground:email
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (!error) {
                                            [lvc setMSettings:mSettings];
                                            [self.navigationController pushViewController:lvc
                                                                                 animated:NO];
                                        }
                                        else {
                                            NSString *lError = [error userInfo][@"error"];
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                                                             message:lError
                                                                                            delegate:self
                                                                                   cancelButtonTitle:@"Dismiss"
                                                                                   otherButtonTitles:nil, nil];
                                            [alert show];
                                        }
                                        [lActivityView.activityIndicator stopAnimating];
                                        [lActivityView removeFromSuperview];
                                    }];
}

- (IBAction)cancelButton_click:(id)sender
{
    [[self navigationController] popToRootViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    CGRect frame = [[UIScreen mainScreen] applicationFrame];
//    frame.origin.y = frame.size.height/8;
//    
//    loginView = [[LoginView alloc] initWithFrame:frame];
//    [self.view addSubview:loginView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)signUpButton_click:(id)sender
{
    SignUpViewController *vc = [[SignUpViewController alloc] init];
    [vc setTitle:@"Sign Up"];
    //[lUser setRegisterFlag:YES];
    //[vc setLUser:lUser];
    
    [self.navigationController pushViewController:vc
                                         animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Register"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(signUpButton_click:)];
    
    
    [[self navigationItem] setRightBarButtonItem:rightButton];
    //[[self navigationItem] setLeftBarButtonItem:leftButton];
    //[[self navigationController]setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
