//
//  LocationHelper.h
//  Qwickd
//
//  Created by Jay on 3/16/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "QWLocation.h"
#import "PlacesInformation.h"

@class CoreDataHelper;

@interface LocationHelper : NSObject <CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic) CLLocationDistance *searchRadius;
@property (nonatomic, strong) QWLocation *qwLocation;
@property (nonatomic) CoreDataHelper *coreDataHelper;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) NSURLConnection *connection;
@property (nonatomic) NSMutableData *placesData;
@property (nonatomic) NSString *reference;
@property (nonatomic) NSString *iconUrl;
@property (nonatomic) NSString *formattedAddress;


- (void)turnOnLocationService;

@end
