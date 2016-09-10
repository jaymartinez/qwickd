//
//  PlaceDetails.h
//  Qwickd
//
//  Created by Jay on 5/27/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlacesData;

@interface PlaceDetails : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * formattedAddress;
@property (nonatomic, retain) NSString * formattedPhoneNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photoReference;
@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) PlacesData *placesData;

@end
