//
//  SurveyView.m
//  Qwickd
//
//  Created by Jay on 5/25/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "SurveyView.h"

@implementation SurveyView

@synthesize goodExpButton, placeCleanButton, recommendButton;
@synthesize commentsTextField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat xPos = 5.0f;
        CGFloat yPos = 0.0f;
        
        //Q1 label
        self.question1Label = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, 200.0f, 25.0f)];
        [self.question1Label setText:@"Good experience?"];
        [self.question1Label setTextAlignment:NSTextAlignmentLeft];
        [self.question1Label setFont:[UIFont fontWithName:@"Verdana" size:13]];
        [self addSubview:self.question1Label];
        
        yPos += 35;
        //Q2 label
        self.question2Label = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, 150.0f, 25.0f)];
        [self.question2Label setText:@"Was the place clean?"];
        [self.question2Label setTextAlignment:NSTextAlignmentLeft];
        [self.question2Label setFont:[UIFont fontWithName:@"Verdana" size:13]];
        [self addSubview:self.question2Label];
        
        yPos += 35;
        //Q3 label
        self.question3Label = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, 180.0f, 25.0f)];
        [self.question3Label setText:@"Recommend to friends?"];
        [self.question3Label setTextAlignment:NSTextAlignmentLeft];
        [self.question3Label setFont:[UIFont fontWithName:@"Verdana" size:13]];
        [self addSubview:self.question3Label];
        
        
        //good exp button
        self.goodExpButton = [[UISegmentedControl alloc] initWithItems:
                              [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"check_mark_green.png"],
                               [UIImage imageNamed:@"redx_sm.png"], nil]];
        [self.goodExpButton setBackgroundColor:[UIColor clearColor]];

        yPos = 0;
        CGRect lFrame = CGRectMake(210.0f, yPos, 75.0f, 30.0f);
        self.goodExpButton.frame = lFrame;
        [self addSubview:self.goodExpButton];
        
        //place clean button
        self.placeCleanButton = [[UISegmentedControl alloc] initWithItems:
                                 [NSArray arrayWithObjects:
                                  [UIImage imageNamed:@"check_mark_green.png"],
                                  [UIImage imageNamed:@"redx_sm.png"], nil]];
        [self.placeCleanButton setBackgroundColor:[UIColor clearColor]];
        
        yPos += 35;
        lFrame.origin.y += 35;
        self.placeCleanButton.frame = lFrame;
        [self addSubview:self.placeCleanButton];
        
        //recommend button
        self.recommendButton = [[UISegmentedControl alloc] initWithItems:
                                [NSArray arrayWithObjects:
                                 [UIImage imageNamed:@"check_mark_green.png"],
                                 [UIImage imageNamed:@"redx_sm.png"], nil]];
        [self.recommendButton setBackgroundColor:[UIColor clearColor]];
        
        yPos += 35;
        lFrame.origin.y += 35;
        self.recommendButton.frame = lFrame;
        [self addSubview:self.recommendButton];
        
        yPos += 55;
        //comments label
        UILabel *commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, 80.0f, 25.0f)];
        [commentsLabel setText:@"Comments"];
        [commentsLabel setFont:[UIFont fontWithName:@"Verdana" size:13.0f]];
        [self addSubview:commentsLabel];
        
        yPos += 35;
        //comments field
        self.commentsTextField = [[UITextField alloc] initWithFrame:CGRectMake(xPos, yPos, frame.size.width-20, 30.0f)];
        [self.commentsTextField setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.commentsTextField];
    }
    return self;
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
