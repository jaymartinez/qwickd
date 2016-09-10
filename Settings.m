//
//  Settings.m
//  Qwickd
//
//  Created by Jay on 12/1/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import "Settings.h"

@implementation Settings

@synthesize coordinate;
@synthesize radius;

- (id)initWithCoordinate:(CLLocationCoordinate2D)pCoordinate
                  radius:(CLLocationDistance)pRadius {
	self = [super init];
	if (self) {
		self.coordinate = pCoordinate;
		self.radius = pRadius;
	}
	return self;
}

- (double)feetToMeters:(double)feet {
    return feet * METERS_IN_A_FOOT;
}


/*
- (id) init
{
    self = [super init];
    
    if(self) {
        self.radius = 500;
    }
    
    return self;
}
 */

@end
