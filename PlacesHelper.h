//
//  PlacesHelper.h
//  Qwickd
//
//  Created by Jay on 4/2/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlacesInformation.h"
#import "QWLocation.h"
#import "CoreDataHelper.h"

@interface PlacesHelper : NSObject
{
    NSMutableData *placesData;
    NSString *reference;
    NSString *iconUrl;
    NSString *formattedAddress;
}

- (PlacesInformation *)fetchPlaces;
- (UIImage *)getPlacePhoto:(NSString *) photoReference;
- (NSData *)getPlacePhotoData:(NSString *)photoReference;

@end
