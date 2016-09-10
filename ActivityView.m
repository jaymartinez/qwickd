//
//  ActivityView.m
//  Qwickd
//
//  Created by Jay on 12/14/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

//static CGFloat const activityIndicatorPadding = 10.f;

#import "ActivityView.h"

@implementation ActivityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
		self.label.textColor = [UIColor whiteColor];
		self.label.backgroundColor = [UIColor whiteColor];
        
		self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
		self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
        
		//[self addSubview:self.label];
		[self addSubview:self.activityIndicator];
    }
    return self;
}

- (void)setLabel:(UILabel *)aLabel {
	//[_label removeFromSuperview];
	[self addSubview:aLabel];
}

- (void)layoutSubviews {
	// center the label and activity indicator.
	//[self.label sizeToFit];
	//self.label.center = CGPointMake(self.frame.size.width / 2 + 10.f, self.frame.size.height / 2);
	//self.label.frame = CGRectIntegral(self.label.frame);
    self.activityIndicator.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    
	//self.activityIndicator.center = CGPointMake(self.label.frame.origin.x - (self.activityIndicator.frame.size.width / 2) - activityIndicatorPadding, self.label.frame.origin.y + (self.label.frame.size.height / 2));
    
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
