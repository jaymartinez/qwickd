//
//  PlacesTableViewCell.m
//  Qwickd
//
//  Created by Jay on 5/22/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "PlacesTableViewCell.h"

@implementation PlacesTableViewCell

@synthesize addressLabel, placeNameLabel;

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
        [self setBackgroundColor:[UIColor clearColor]];
        
        //container dimensions
        CGFloat frameWidth = frame.size.width;
        CGFloat frameHeight = 75.0f;
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
        [containerView setBackgroundColor:[UIColor clearColor]];
        [containerView.layer setCornerRadius:10.0f];
        [self addSubview:containerView];
        
        //image of the place
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 35, 35)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[UIImage imageNamed:@"luau1_sm.png"]];
        [containerView addSubview:imageView];
        
        self.placeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 150, 25)];
        //[self.placeNameLabel setText:@"Starbucks"];
        [self.placeNameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.placeNameLabel setFont:[UIFont fontWithName:@"Verdana" size:14.0f]];
        [containerView addSubview:self.placeNameLabel];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 20, 200, 25)];
        //[self.addressLabel setText:@"1523 Pine St. Redding, Ca 96002"];
        [self.addressLabel setTextAlignment:NSTextAlignmentLeft];
        [self.addressLabel setFont:[UIFont fontWithName:@"Verdana" size:10.0f]];
        [containerView addSubview:self.addressLabel];
         */
        
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, 300.0f, 60.0f)];
        [containerView setBackgroundColor:[UIColor clearColor]];
        [containerView.layer setCornerRadius:10.0f];
        [self addSubview:containerView];
        
        //image of the place
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        //[imageView setImage:[UIImage imageNamed:@"luau1_sm.png"]];
        [containerView addSubview:imageView];
        
        self.placeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 250, 25)];
        [self.placeNameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.placeNameLabel setFont:[UIFont fontWithName:@"Verdana" size:14.0f]];
        [containerView addSubview:self.placeNameLabel];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 35, 250, 25)];
        [self.addressLabel setTextAlignment:NSTextAlignmentLeft];
        [self.addressLabel setFont:[UIFont fontWithName:@"Verdana" size:12.0f]];
        [containerView addSubview:self.addressLabel];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
