//
//  PlaceDetailsView.m
//  Qwickd
//
//  Created by Jay on 5/18/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "PlaceDetailsView.h"

@implementation PlaceDetailsView

@synthesize phoneNumberLabel,addressLabel,websiteLabel,placeName;
@synthesize placeImage;
@synthesize websiteTextView, phoneNumberTextView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat xPos = 0.0f;
        CGFloat yPos = 5.0f;
        
        //Place Name
        self.placeName = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, frame.size.width, 25.0f)];
        [self.placeName setTextAlignment:NSTextAlignmentCenter];
        [self.placeName setFont:[UIFont fontWithName:@"Verdana" size:16.0f]];
        [self addSubview:self.placeName];
        
        //Place address
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos+25, frame.size.width, 25.0f)];
        [self.addressLabel setTextAlignment:NSTextAlignmentCenter];
        [self.addressLabel setFont:[UIFont fontWithName:@"Verdana" size:12.0f]];
        [self addSubview:self.addressLabel];
        
        //Place phone number
        /*
        self.phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos+45, frame.size.width, 25.0f)];
        [self.phoneNumberLabel setTextAlignment:NSTextAlignmentCenter];
        [self.phoneNumberLabel setFont:[UIFont fontWithName:@"Verdana" size:12.0f]];
        [self addSubview:self.phoneNumberLabel];
        */
        self.phoneNumberTextView = [[UITextView alloc] initWithFrame:CGRectMake(xPos, yPos+45, frame.size.width, 25.0f)];
        [self.phoneNumberTextView setBackgroundColor:[UIColor clearColor]];
        [self.phoneNumberTextView setTextAlignment:NSTextAlignmentCenter];
        [self.phoneNumberTextView setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [self.phoneNumberTextView setEditable:NO];
        [self.phoneNumberTextView setScrollEnabled:NO];
        [self.phoneNumberTextView setDataDetectorTypes:UIDataDetectorTypePhoneNumber];
        [self addSubview:self.phoneNumberTextView];
        
        //website
        /*
        self.websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos+65, frame.size.width, 35.0f)];
        [self.websiteLabel setTextAlignment:NSTextAlignmentCenter];
        [self.websiteLabel setNumberOfLines:0];
        [self.websiteLabel setFont:[UIFont fontWithName:@"Verdana" size:12.0f]];
        [self addSubview:self.websiteLabel];
        */
        
        self.websiteTextView = [[UITextView alloc] initWithFrame:CGRectMake(xPos, yPos+65, frame.size.width, 35.0f)];
        [self.websiteTextView setBackgroundColor:[UIColor clearColor]];
        [self.websiteTextView setTextAlignment:NSTextAlignmentCenter];
        [self.websiteTextView setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [self.websiteTextView setEditable:NO];
        [self.websiteTextView setScrollEnabled:NO];
        [self.websiteTextView setDataDetectorTypes:UIDataDetectorTypeLink];
        [self addSubview:self.websiteTextView];
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
