//
//  SurveyView.h
//  Qwickd
//
//  Created by Jay on 5/25/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyView : UIView

@property (nonatomic) IBOutlet UITextField *commentsTextField;
@property (nonatomic) IBOutlet UISegmentedControl *goodExpButton;
@property (nonatomic) IBOutlet UISegmentedControl *placeCleanButton;
@property (nonatomic) IBOutlet UISegmentedControl *recommendButton;
@property (nonatomic) UILabel *question1Label;
@property (nonatomic) UILabel *question2Label;
@property (nonatomic) UILabel *question3Label;
@end
