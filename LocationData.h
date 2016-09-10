//
//  LocationData.h
//  Qwickd
//
//  Created by Jay on 5/26/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocationData : NSManagedObject

@property (nonatomic, retain) NSNumber * lastLatitude;
@property (nonatomic, retain) NSNumber * lastLongitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * recordedAt;

@end
