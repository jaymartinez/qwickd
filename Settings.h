//
//  Settings.h
//  Qwickd
//
//  Created by Jay on 12/1/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

static double const METERS_IN_A_FOOT = 0.3048;


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Settings : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CLLocationDistance radius;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                  radius:(CLLocationDistance)radius;

- (double)feetToMeters:(double)value;

@end
