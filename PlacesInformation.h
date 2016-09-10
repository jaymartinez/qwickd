//
//  PlacesInformation.h
//  Qwickd
//
//  Created by Jay on 4/1/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlacesInformation : NSObject

@property (nonatomic) NSMutableArray *placesDictionaryArray;
@property (nonatomic) NSMutableArray *placeDetailsDictionaryArray;
@property (nonatomic) NSArray *placeNames;

@property (nonatomic) NSString *placeName;
@property (nonatomic) NSString *placeId;
@property (nonatomic) NSString *placeAddress;
@property (nonatomic) UIImage *placeImage;
@property (nonatomic) NSString *websiteUrl;
@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSData *imageData;

@end
