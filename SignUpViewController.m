//
//  SignUpViewController.m
//  Qwickd
//
//  Created by Jay on 10/21/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

//@synthesize lUser;
@synthesize signUpButton;
@synthesize mSettings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //lUser = [[User alloc] init];
        mSettings = [[Settings alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.signUpButton.enabled = NO;
    self.signUpButton.alpha = 0.7;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:emailField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:firstNameField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:lastNameField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:passwordField1];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:passwordField2];
}

- (void)inputChanged:(NSNotification *)note
{
    BOOL enableSignUpButton = NO;
    self.signUpButton.alpha = 0.7;
    
    if (emailField.text != nil &&
        firstNameField.text != nil &&
        lastNameField.text != nil &&
        passwordField1.text != nil &&
        passwordField2.text != nil &&
        emailField.text.length > 0 &&
        firstNameField.text.length > 0 &&
        lastNameField.text.length > 0 &&
        passwordField1.text.length > 0 &&
        passwordField2.text.length > 0)
    {
        enableSignUpButton = YES;
        self.signUpButton.alpha = 1.0;
    }
    
    self.signUpButton.enabled = enableSignUpButton;
}

- (IBAction)loginButton_click:(id)sender
{
    LoginViewController *lvc = [[LoginViewController alloc] init];
    [lvc setTitle:@"Login"];
    [lvc setMSettings:mSettings];
    //[lUser setRegisterFlag:NO];
    //[lvc setLUser:lUser];
    
    [self.navigationController pushViewController:lvc
                                         animated:NO];

}

- (IBAction)signUpButton_click:(id)sender
{
    LandingPageViewController *lvc = [[LandingPageViewController alloc] init];
    NSString *firstName = [[NSString alloc] initWithString:[firstNameField text]];
    NSString *lastName = [[NSString alloc] initWithString:[lastNameField text]];
    NSString *email = [[NSString alloc] initWithString:[emailField text]];
    NSString *password1 = [[NSString alloc] initWithString:[passwordField1 text]];
    NSString *password2 = [[NSString alloc] initWithString:[passwordField2 text]];
    //NSLog(@"Password1: %@", password1);
    //NSLog(@"Password2: %@", password2);
    if (![password1 isEqualToString:password2])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error"
                                                        message:@"Passwords do not match"
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
    //Verify email is valid
    NSError *error;
    NSRegularExpression *lExpr = [NSRegularExpression regularExpressionWithPattern:@"\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}\\b"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    /*
    if (error) {
        NSLog(@"Error Message: %@", error);
        return;
    }
     */
    
    //Check for valid matches against the regular expression
    NSUInteger lMatches = [lExpr numberOfMatchesInString:email
                                                 options:0
                                                   range:NSMakeRange(0, [email length])];
    
    //Let's let the user know they entered a bogus email
    if (lMatches == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error"
                                                         message:@"Invalid email format"
                                                        delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //Sign up user
    PFUser *pfUser = [PFUser user];
    pfUser.username = email;
    pfUser.password = password1;
    pfUser[@"FirstName"] = firstName;
    pfUser[@"LastName"] = lastName;
    
    //Start the activity indicator
    ActivityView *lActivityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    [lActivityView.activityIndicator startAnimating];
    [lActivityView layoutSubviews];
    [self.view addSubview:lActivityView];
    
    [pfUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error && succeeded) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                           message:@"Registration Complete!"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            
            [alert show];
            [lvc setMSettings:mSettings];
            [self.navigationController pushViewController:lvc
                                                 animated:NO];
            
        }
        else {
            NSString *err = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error"
                                                             message:err
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(loginButton_click:)];
    
    
    [[self navigationItem] setRightBarButtonItem:rightButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
