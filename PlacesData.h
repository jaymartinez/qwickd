//
//  PlacesData.h
//  Qwickd
//
//  Created by Jay on 5/28/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlaceDetails;

@interface PlacesData : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * iconUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photoReference;
@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSString * rating;
@property (nonatomic, retain) NSDate * recordedAt;
@property (nonatomic, retain) NSData * defaultImageData;
@property (nonatomic, retain) PlaceDetails *placeDetails;

@end
