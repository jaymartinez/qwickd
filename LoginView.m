//
//  LoginView.m
//  Qwickd
//
//  Created by Jay on 3/26/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

@synthesize emailField, passwordField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        CGFloat buttonWidth = 60.0f;
//        closeButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-buttonWidth, 0, buttonWidth, 36.0f)];
//        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
//        [closeButton setContentMode:UIViewContentModeCenter];
//        [closeButton setBackgroundColor:[UIColor clearColor]];
//        [closeButton addTarget:self
//                        action:@selector(closePressed)
//              forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:closeButton];
        
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        CGFloat textfieldWidth = frame.size.width*0.8f;
        CGFloat textfieldHeight = 31.0f;
        CGFloat curX = textfieldWidth/8;
        CGFloat curY = 20.0f;
        UIColor *whiteBackround = [UIColor whiteColor];
        
        UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, curY, frame.size.width, 25.0f)];
        [emailLabel setBackgroundColor:[UIColor clearColor]];
        [emailLabel setTextAlignment:NSTextAlignmentCenter];
        [emailLabel setText:@"Email"];
        [self addSubview:emailLabel];
        
        curY += 30;
        self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(curX, curY, textfieldWidth, textfieldHeight)];
        [self.emailField setBackgroundColor:whiteBackround];
        [self.emailField setDelegate:self];
        [self.emailField setKeyboardType:UIKeyboardTypeEmailAddress];
        [self.emailField setReturnKeyType:UIReturnKeyDone];
        [self addSubview:self.emailField];
        
        curY += 40;
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, curY, frame.size.width, 25.0f)];
        [passwordLabel setBackgroundColor:[UIColor clearColor]];
        [passwordLabel setTextAlignment:NSTextAlignmentCenter];
        [passwordLabel setText:@"Password"];
        [self addSubview:passwordLabel];
        
        curY += 30;
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(curX, curY, textfieldWidth, textfieldHeight)];
        [self.passwordField setBackgroundColor:whiteBackround];
        [self.passwordField setDelegate:self];
        [self.passwordField setKeyboardType:UIKeyboardTypeDefault];
        [self.passwordField setReturnKeyType:UIReturnKeyDone];
        [self addSubview:self.passwordField];
        
    }
    return self;
}

- (void)closePressed
{
    [self removeFromSuperview];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
