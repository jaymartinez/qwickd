//
//  QWPlaces.h
//  Qwickd
//
//  Created by Jay on 12/9/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataHelper.h"

@interface QWPlaces : NSObject <NSXMLParserDelegate>
{
    NSURLConnection *connection;
    NSMutableData *placesData;
}

//contains a list of names of places returned by the webservice
@property (nonatomic) NSURLConnection *connection;
@property (nonatomic) NSMutableArray *placeNames;
@property (nonatomic) NSMutableDictionary *placesDictionary;
@property (nonatomic) NSMutableArray *placesDictionaryArray;
@property (nonatomic) NSMutableArray *placeDetailsDictionaryArray;
@property (nonatomic) NSMutableData *placesData;
@property (nonatomic) NSString *nextPageToken;
@property (nonatomic) NSString *reference;
@property (nonatomic) NSString *iconUrl;
@property (nonatomic) NSString *formattedAddress;
@property (nonatomic, readonly) CoreDataHelper *coreDataHelper;

//an array of place types (i.e., restaraunt, bakery, museum, etc)
@property (nonatomic, retain) NSArray *placeTypes;

- (NSMutableArray *)fetchPlaces;

@end
