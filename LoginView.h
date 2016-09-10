//
//  LoginView.h
//  Qwickd
//
//  Created by Jay on 3/26/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView <UITextFieldDelegate>
{
    IBOutlet UIButton *closeButton;
}

@property (nonatomic) UITextField *emailField;
@property (nonatomic) UITextField *passwordField;


@end
