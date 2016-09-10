//
//  QWLocation.h
//  Qwickd
//
//  Created by Jay on 12/4/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface QWLocation : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CLLocationDistance radius;
@property (nonatomic, assign) CLLocation *currentLocation;
@property (nonatomic, assign) CLLocation *oldLocation;
@property (nonatomic, assign) CLLocationAccuracy locationAccuracy;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                accuracy:(CLLocationAccuracy)accuracy
         currentLocation:(CLLocation *)location
             oldLocation:(CLLocation *)oldLocation;

@end
