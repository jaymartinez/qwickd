//
//  CoreDataHelper.h
//  Qwickd
//
//  Created by Jay on 12/9/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "PlacesData.h"
#import "PlaceDetails.h"
#import "PlacesInformation.h"

@interface CoreDataHelper : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) NSManagedObjectContext *context;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSArray *)fetchData:(NSString *)pEntity;
//- (void)savePlacesData:(NSDictionary *)pDictionary;
//- (void)savePlaceDetailsData:(NSDictionary *)pDictionary;
- (void)saveSearchRadius:(double)pRadius;
- (void)deleteManagedObject:(NSString *)pEntityName;
- (void)saveContext;
- (void)savePlacesData:(PlacesInformation *)placesInformation;

@end