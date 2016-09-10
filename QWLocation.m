//
//  QWLocation.m
//  Qwickd
//  (-)(-)
//  Created by Jay on 12/4/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import "QWLocation.h"

@implementation QWLocation

@synthesize coordinate;
@synthesize radius;

- (id)initWithCoordinate:(CLLocationCoordinate2D)pCoordinate
                accuracy:(CLLocationAccuracy)pAccuracy
         currentLocation:(CLLocation *)pLocation
             oldLocation:(CLLocation *)pOldLocation{
    self = [super init];
    if (self) {
        self.coordinate = pCoordinate;
        self.currentLocation = pLocation;
        self.locationAccuracy = pAccuracy;
        self.oldLocation = pOldLocation;
    }
    return self;
}

@end
