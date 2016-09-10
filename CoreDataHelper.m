//
//  CoreDataHelper.m
//  Qwickd
//
//  Created by Jay on 12/9/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import "CoreDataHelper.h"
#import "LocationData.h"
#import "ActivityView.h"
#import "SettingsData.h"
#import "PlaceDetails.h"
#import "PlacesHelper.h"

@implementation CoreDataHelper
@synthesize context = _context;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - Core Data stack

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Qwickd" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)context
{
    if (_context != nil) {
        return _context;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:coordinator];
    }
    return _context;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Qwickd.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.context;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//Fetches data from pEntity
- (NSArray *)fetchData:(NSString *)pEntity {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:pEntity
                                                      inManagedObjectContext:self.context];
    [fetchRequest setEntity:locationEntity];
    
    
    NSArray *lResults = [self.context executeFetchRequest:fetchRequest
                                                    error:&error];
    
    if (error) {
        NSLog(@"Something happened during the fetch");
    }
    
    return lResults;
}

//Serializes the place data and stores to core data
- (void)savePlacesData:(PlacesInformation *)placesInformation
{
    PlacesHelper *lPlacesHelper = [[PlacesHelper alloc] init];
    NSError *error;
    
    for (int i = 0; i < placesInformation.placesDictionaryArray.count; i++) {
        NSDictionary *lPlacesDictionary = [placesInformation.placesDictionaryArray objectAtIndex:i];
        
        //serialize the places dictionary
        NSData *lPlaceData = [NSJSONSerialization dataWithJSONObject:lPlacesDictionary
                                                             options:NSJSONWritingPrettyPrinted
                                                               error:&error];
        
        PlacesData *placesData = [NSEntityDescription insertNewObjectForEntityForName:PLACES_ENTITY
                                                               inManagedObjectContext:self.context];
        
        //get the values for the place
        NSString *lName = [lPlacesDictionary objectForKey:@"name"];
        NSString *lIconUrl = [lPlacesDictionary objectForKey:@"icon"];
        NSString *lPlaceId = [lPlacesDictionary objectForKey:@"id"];
        NSDictionary *geometryDictionary = [[lPlacesDictionary objectForKey:@"geometry"]objectForKey:@"location"];
        NSString *lPlaceLat = [geometryDictionary objectForKey:@"lat"];
        NSString *lPlaceLong = [geometryDictionary objectForKey:@"lng"];
        NSArray *lPhotos = [lPlacesDictionary objectForKey:@"photos"];
        NSString *lPlacePhotoRef = [[lPhotos objectAtIndex:0] objectForKey:@"photo_reference"];
        NSURL *lDefaultImageUrl = [NSURL URLWithString:lIconUrl];
        NSData *lDefaultImageData = [[NSData alloc] initWithContentsOfURL:lDefaultImageUrl];
        placesData.defaultImageData = lDefaultImageData;
        placesData.photoReference = lPlacePhotoRef;
        placesData.data = lPlaceData;
        placesData.placeId = lPlaceId;
        placesData.name = lName;
        placesData.iconUrl = lIconUrl;
        placesData.recordedAt = [NSDate date];

        
        //link the place details to the place
        PlaceDetails *placeDetails = [NSEntityDescription insertNewObjectForEntityForName:PLACE_DETAILS_ENTITY
                                                                   inManagedObjectContext:self.context];
        for (int i = 0; i < placesInformation.placeDetailsDictionaryArray.count; i++) {
            NSDictionary *lDetails = [placesInformation.placeDetailsDictionaryArray objectAtIndex:i];
            NSString *lDetailsId = [lDetails objectForKey:@"id"];
            if ([lDetailsId isEqualToString:lPlaceId]) {
                NSString *lPhoneNumber = [lDetails objectForKey:@"formatted_phone_number"];
                NSString *lWebsite = [lDetails objectForKey:@"website"];
                NSString *lPlaceDetailsName = [lDetails objectForKey:@"name"];
                //NSString *lDetailsAddress = [lDetails objectForKey:@"formatted_address"];
                NSData *lDetailsData = [NSJSONSerialization dataWithJSONObject:lDetails
                                                                     options:NSJSONWritingPrettyPrinted
                                                                       error:&error];
                //Build up the address with the address components
                NSArray *lAddressComponents = [lDetails objectForKey:@"address_components"];
                NSString *lBuffer = [[NSString alloc] init];
                NSString *lStreetNumber = [[NSString alloc] init];
                NSString *lRoute = [[NSString alloc] init];
                NSString *lLocality = [[NSString alloc] init];
                NSString *lState = [[NSString alloc] init];
                for (int i = 0; i < lAddressComponents.count; i++) {
                    NSArray *lTypes = [[lAddressComponents objectAtIndex:i] objectForKey:@"types"];
                    for (NSString *lType in lTypes) {
                        if ([lType isEqualToString:@"street_number"]) {
                            NSString *lStreetLong = [[lAddressComponents objectAtIndex:i] objectForKey:@"long_name"];
                            NSString *lStreetShort = [[lAddressComponents objectAtIndex:i] objectForKey:@"short_name"];
                            if (lStreetShort == nil || lStreetShort.length == 0)
                                lStreetNumber = lStreetLong;
                            else
                                lStreetNumber = lStreetShort;
                            break;
                        } else if ([lType isEqualToString:@"route"]) {
                            NSString *lRouteShort = [[lAddressComponents objectAtIndex:i] objectForKey:@"short_name"];
                            NSString *lRouteLong = [[lAddressComponents objectAtIndex:i] objectForKey:@"long_name"];
                            if (lRouteShort == nil || lRouteShort.length == 0)
                                lRoute = lRouteLong;
                            else
                                lRoute = lRouteShort;
                            break;
                        } else if ([lType isEqualToString:@"locality"]) {
                            NSString *lLocalityShort = [[lAddressComponents objectAtIndex:i] objectForKey:@"short_name"];
                            NSString *lLocalityLong = [[lAddressComponents objectAtIndex:i] objectForKey:@"long_name"];
                            if (lLocalityShort == nil || lLocalityShort.length == 0)
                                lLocality = lLocalityLong;
                            else
                                lLocality = lLocalityShort;
                            break;
                        } /*else if ([lType isEqualToString:@"administrative_area_level_1"] ||
                                   [lType isEqualToString:@"political"]) {
                            NSString *lStateShort = [[lAddressComponents objectAtIndex:i] objectForKey:@"short_name"];
                            NSString *lStateLong = [[lAddressComponents objectAtIndex:i] objectForKey:@"long_name"];
                            if (lStateShort == nil || lStateShort.length == 0)
                                lState = lStateLong;
                            else
                                lState = lStateShort;
                            break;
                        }*/
                    }
                }
                
                //this needs to be reworked eventually
                /*if ((lStreetNumber == nil || lStreetNumber.length == 0) && (lRoute == nil || lRoute.length)) {
                    lBuffer = [lBuffer stringByAppendingString:lLocality];
                    lBuffer = [lBuffer stringByAppendingString:@" "];
                    lBuffer = [lBuffer stringByAppendingString:lState];
                } else {*/
                    lBuffer = lStreetNumber;
                    lBuffer = [lBuffer stringByAppendingString:@" "];
                    lBuffer = [lBuffer stringByAppendingString:lRoute];
                    lBuffer = [lBuffer stringByAppendingString:@", "];
                    lBuffer = [lBuffer stringByAppendingString:lLocality];
                    lBuffer = [lBuffer stringByAppendingString:@" "];
                    lBuffer = [lBuffer stringByAppendingString:lState];
                //}
                
                
                //Build a comma-separated list of place details photo reference strings
                NSString *lPhotoReferences = [[NSString alloc] init];
                NSString *lPhotoReference = [[NSString alloc] init];
                NSArray *lPlaceDetailsPhotos = [lDetails objectForKey:@"photos"];
                NSData *lImageData = nil;//[[NSData alloc] init];
                if (lPlaceDetailsPhotos != nil) {
                    lPhotoReferences = [[lPlaceDetailsPhotos objectAtIndex:0] objectForKey:@"photo_reference"];
                    lPhotoReference = [[lPlaceDetailsPhotos objectAtIndex:0] objectForKey:@"photo_reference"];
                    
                    //Get the image data so we can store it to coredata
                    lImageData = [[NSData alloc] initWithData:[lPlacesHelper getPlacePhotoData:lPhotoReference]];
                    
                }
                
                //NSString *lFinalPhotoRefs = [NSString alloc] initWithString:
                //NSString *lFinalPhotoRefs = [lPhotoReferences substringToIndex:[lPhotoReferences length] - 1];
                
                placeDetails.imageData = lImageData;
                placeDetails.name = lPlaceDetailsName;
                //placeDetails.formattedAddress = lDetailsAddress;
                placeDetails.formattedAddress = lBuffer;
                placeDetails.formattedPhoneNumber = lPhoneNumber;
                placeDetails.photoReference = lPhotoReferences;
                placeDetails.data = lDetailsData;
                placeDetails.placeId = lDetailsId;
                placeDetails.placesData = placesData;
                placeDetails.website = lWebsite;
                placesData.placeDetails = placeDetails;
                break;
            }
        }
        
        //save to CoreData storage
        if (![self.context save:&error]) {
            NSLog(@"Something happened when saving coredata places and location data");
        }
        
        
        /**** Save to database *****/
        
        NSNumber *lLatitude, *lLongitude;
        BOOL canSave = YES;
        //Grab all places that match the current place we are operating on, and
        // only add it if no place exists that match the coordinates of our current place.
        PFQuery *query = [PFQuery queryWithClassName:PLACES_ENTITY];
        [query whereKey:@"name" equalTo:lName];
        NSArray *lResults = [query findObjects];
        for (PFObject *lObject in lResults) {
            lLatitude = [lObject objectForKey:@"latitude"];
            lLongitude = [lObject objectForKey:@"longitude"];
                
            double tempLat = lLatitude.doubleValue;
            double tempLong = lLongitude.doubleValue;
            double locationLat = lPlaceLat.doubleValue;
            double locationLong = lPlaceLong.doubleValue;
            NSString *tempLatStr = [NSString stringWithFormat:@"%.3f", tempLat];
            NSString *locationLatStr = [NSString stringWithFormat:@"%.3f", locationLat];
            NSString *tempLongStr = [NSString stringWithFormat:@"%.3f", tempLong];
            NSString *locationLongStr = [NSString stringWithFormat:@"%.3f", locationLong];
            if ([tempLatStr isEqualToString:locationLatStr] && [tempLongStr isEqualToString:locationLongStr]) {
                canSave = NO;
                break;
            }
        }
        if (canSave) {
            PFObject *placesObject = [PFObject objectWithClassName:PLACES_ENTITY];
            placesObject[@"name"] = lName;
            placesObject[@"iconUrl"] = lIconUrl;
            placesObject[@"latitude"] = lPlaceLat;
            placesObject[@"longitude"] = lPlaceLong;
            placesObject[@"placeData"] = lPlaceData;
            placesObject[@"placeId"] = lPlaceId;
            [placesObject save];
        }
    }
}

- (void)deleteManagedObject:(NSString *)pEntityName {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:pEntityName];
    NSArray *objects = [self.context executeFetchRequest:request error:&error];
    if (objects == nil) {
        NSLog(@"No objects to delete!!!");
    } else {
        for (NSManagedObject *object in objects) {
            [self.context deleteObject:object];
        }
        //if (![self.context save:&error]) {
          //  NSLog(@"Something happened when trying to delete the managed object.");
        //}
    }
    
    //NSArray *temp = [self fetchData:LOCATION_ENTITY];
    
}

- (void)saveSearchRadius:(double)pRadius {
    NSError *error;
    SettingsData *settingsData = [NSEntityDescription insertNewObjectForEntityForName:SETTINGS_ENTITY
                                                               inManagedObjectContext:self.context];
    
    settingsData.searchRadius = [NSNumber numberWithDouble:pRadius];
    if (![self.context save:&error]) {
        NSLog(@"Something happened when saving coredata SettingsData.");
    }
}

@end