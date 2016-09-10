//
//  LocationHelper.m
//  Qwickd
//
//  Created by Jay on 3/16/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "LocationHelper.h"
#import "SettingsData.h"
#import "CoreDataHelper.h"

@implementation LocationHelper

@synthesize currentLocation;
@synthesize searchRadius;
//@synthesize placesData;
//@synthesize iconUrl, formattedAddress;
@synthesize locationManager = _locationManager;
@synthesize coreDataHelper = _coreDataHelper;


- (CoreDataHelper *)coreDataHelper {
    if (_coreDataHelper != nil) {
        return _coreDataHelper;
    }
    
    _coreDataHelper = [[CoreDataHelper alloc] init];
    return _coreDataHelper;
}

- (CLLocationManager *)locationManager
{
	
    if (_locationManager != nil) {
		return _locationManager;
	}
	
	_locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.delegate = self;
	
	return _locationManager;
}

//This gets called when our message is posted on the notification center signifying
//  that the timer fired so we can begin tracking the user's location.
- (void)turnOnLocationService
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
}

//Update user's location
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    //Objects in the locations array are organized in the order which they occurred, so the
    // most recent location update is at the end of the array
    NSInteger size = locations.count;
    self.currentLocation = [locations objectAtIndex:size - 1];
    
    //See if the old location is available
    CLLocation *oldLocation = nil;
    if (size > 1) {
        oldLocation = [locations objectAtIndex:size - 2];
    }
    
    //initialize our model with useful data
    self.qwLocation = [[QWLocation alloc] initWithCoordinate:self.locationManager.location.coordinate
                                                    accuracy:self.locationManager.desiredAccuracy
                                             currentLocation:self.currentLocation
                                                 oldLocation:oldLocation];
    
    //Get the most recent cached location data
    NSArray *locationData = [self.coreDataHelper fetchData:LOCATION_ENTITY];
    if (locationData != nil && locationData.count > 0) {
        LocationData *lLocation = [locationData objectAtIndex:[locationData count] - 1];
        //NSDate *recordedAt = [lLocation recordedAt];
        double locationLat = lLocation.latitude.doubleValue;
        double locationLong = lLocation.longitude.doubleValue;
        NSString *locationLatStr = [NSString stringWithFormat:@"%.4f", locationLat];
        NSString *locationLongStr = [NSString stringWithFormat:@"%.4f", locationLong];
        double curLat = self.currentLocation.coordinate.latitude;
        double curLong = self.currentLocation.coordinate.longitude;
        NSString *curLatStr = [NSString stringWithFormat:@"%.4f", curLat];
        NSString *curLongStr = [NSString stringWithFormat:@"%.4f", curLong];
        //NSTimeInterval elapsed = [recordedAt timeIntervalSinceDate:[NSDate date]];
        //NSLog(@"Location time elapsed: %f", elapsed);
        //if cached data is different than user's current location, update cache and db
        if (![locationLatStr isEqualToString:curLatStr] && ![locationLongStr isEqualToString:curLongStr]) {
            [self saveLocation];
        }
        /***Take this out until we test power consumption by keeping location services running
        else {
            [self.locationManager stopUpdatingLocation];
        }*/
    }
    else {
        [self saveLocation];
    }
    
}

//This delegates to methods responsible for updating our CoreData stuff as well as our
// external database
- (void)saveLocation
{
    [self updateLocationCache];
    
    //TODO - only insert into db if the user's most recent location entry doesn't match their current location
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [self saveLocationToDatabase:nil];
    }
    
    //[self.locationManager stopUpdatingLocation];
}

- (void)updateLocationCache
{
    NSError *error;
    
    //Clear out the old location data
    [[self coreDataHelper] deleteManagedObject:LOCATION_ENTITY];
    
    
    //get user's current location and update local store
    
    LocationData *lLocation = [NSEntityDescription insertNewObjectForEntityForName:LOCATION_ENTITY
                                                            inManagedObjectContext:[[self coreDataHelper] context]];
    
    CLLocation *oldLocation = [self.qwLocation oldLocation];
    CLLocation *newLocation = [self.qwLocation currentLocation];
    if (oldLocation != nil) {
        NSNumber *oldLat = [NSNumber numberWithDouble:oldLocation.coordinate.latitude];
        NSNumber *oldLong = [NSNumber numberWithDouble:oldLocation.coordinate.longitude];
        if (oldLat != nil && oldLong != nil) {
            lLocation.lastLatitude = oldLat;
            lLocation.lastLongitude = oldLong;
        }
    }
    NSNumber *newLat = [NSNumber numberWithDouble:newLocation.coordinate.latitude];
    NSNumber *newLong = [NSNumber numberWithDouble:newLocation.coordinate.longitude];
    lLocation.latitude = newLat;
    lLocation.longitude = newLong;
    lLocation.recordedAt = [NSDate date];
    
    
    if (![[self.coreDataHelper context] save:&error]) {
        NSString *errorDesc = @"localized desc: ";
        errorDesc = [errorDesc stringByAppendingString:[error localizedDescription]];
        //errorDesc = [errorDesc stringByAppendingString:@"\n"];
        //errorDesc = [errorDesc stringByAppendingString:[error description]];
        
        NSLog(@"An error occurred when saving to CoreData: %@", errorDesc);
    }
}

- (void) saveLocationToDatabase:(NSNotification *)note
{
    //NSArray *location = [self.coreDataHelper fetchData:LOCATION_ENTITY];
    //if (location != nil && location.count > 0) {
        //LocationData *curLocation = [location objectAtIndex:[location count] - 1];
        //LocationData *lastLocation = nil;
        CLLocation *curLocation = [self.qwLocation currentLocation];
        CLLocation *lastLocation = [self.qwLocation oldLocation];
    /*
        if (location.count > 1) {
            lastLocation = [location objectAtIndex:[location count] - 2];
        }
     */
        
        //Pull out the coordinates into a CLLocation object for use in our Parse call.
        CLLocation *lCoordinate = [[CLLocation alloc] initWithLatitude:curLocation.coordinate.latitude
                                                             longitude:curLocation.coordinate.longitude];
        
        double lLat = curLocation.coordinate.latitude;
        double lLong = curLocation.coordinate.longitude;
        double lOldLat = 0.0f;
        double lOldLong = 0.0f;
        if (lastLocation != nil) {
            lOldLat = lastLocation.coordinate.latitude;
            lOldLong = lastLocation.coordinate.longitude;
        }
        
        NSString *latStr = [NSString stringWithFormat:@"%f", lLat];
        NSString *longStr = [NSString stringWithFormat:@"%f", lLong];
        NSString *lMessage = @"Lat: %f: ";
        lMessage = [lMessage stringByAppendingString:latStr];
        lMessage = [lMessage stringByAppendingString:@"\nLong: %f"];
        lMessage = [lMessage stringByAppendingString:longStr];
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location saved to Parse"
                                                        message:lMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil, nil];
        [alert show];
         */
        
        
        /******TODO(maybe not needed!!): check if location exists already for current user. check if the dateRecorded was
         less than maybe 1 or 2 minutes. The location service zeroes in on the user's current location, so
         the didUpdateLocations() method gets called a lot until the location settles down. 
         ***********/

        
        //Save location data to database
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:lCoordinate];
        PFObject *object = [PFObject objectWithClassName:LOCATION_ENTITY];
        [object setObject:geoPoint forKey:COL_LOCATION];
        [object setObject:[NSNumber numberWithDouble:lOldLat] forKey:COL_LAST_LAT];
        [object setObject:[NSNumber numberWithDouble:lOldLong] forKey:COL_LAST_LONG];
        
        if ([PFUser currentUser] != nil) {
            [object setObject:[PFUser currentUser] forKey:COL_USER];
        }
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"An error occured trying to save PFObject. Details: %@", [error description]);
            }
        }];
    //}
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"Location manager failure: %@", [error description]);
    
    if (error.code == kCLErrorDenied) {
		[self.locationManager stopUpdatingLocation];
	} else if (error.code == kCLErrorLocationUnknown) {
        [self.locationManager stopUpdatingLocation];
		// todo: retry?
		// set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
        NSLog(@"Error retrieving location");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
		                                                message:[error description]
		                                               delegate:nil
		                                      cancelButtonTitle:nil
		                                      otherButtonTitles:@"Ok", nil];
		[alert show];
        NSLog(@"Error retrieving location");
    }
}

@end
