//
//  HomeView.h
//  Qwickd
//
//  Created by Jay on 3/26/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeView : UIView
{
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *signupButton;
    IBOutlet UIButton *loginButton;
}

@property (nonatomic) UIImage *background;

@end
