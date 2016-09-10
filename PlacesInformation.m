//
//  PlacesInformation.m
//  Qwickd
//
//  Created by Jay on 4/1/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "PlacesInformation.h"

@implementation PlacesInformation
@synthesize placeDetailsDictionaryArray, placesDictionaryArray;
@synthesize placeNames;
@synthesize placeName, placeId, placeAddress, websiteUrl;
@synthesize placeImage;
@synthesize imageData;

- (id)init
{
    if (self = [super init]) {
        self.placesDictionaryArray = [[NSMutableArray alloc] init];
        self.placeDetailsDictionaryArray = [[NSMutableArray alloc] init];
        self.placeNames = [[NSArray alloc] init];
        
        self.placeImage = [[UIImage alloc] init];
        self.placeId = [[NSString alloc] init];
        self.placeAddress = [[NSString alloc] init];
        self.websiteUrl = [[NSString alloc] init];
        self.placeName = [[NSString alloc] init];
    }
    
    return self;
}



@end
