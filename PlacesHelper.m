//
//  PlacesHelper.m
//  Qwickd
//
//  Created by Jay on 4/2/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "PlacesHelper.h"

@implementation PlacesHelper

/*************************************************************************************************
Fetch Places Data
*************************************************************************************************/
- (PlacesInformation *)fetchPlaces
{
    //Local variables
    PlacesInformation *placesInformation = [[PlacesInformation alloc] init];
    //NSString *nextPageToken = [[NSString alloc] init];
    NSMutableArray *placesDictionaryArray = [[NSMutableArray alloc] init];
    NSMutableArray *placeDetailsDictionaryArray = [[NSMutableArray alloc] init];
    NSMutableArray *placeNames = [[NSMutableArray alloc] init];
    NSArray *placeTypes = [[NSArray alloc] init];
    NSError *error;
    
    //read from plist file the place types that we're supporting
    NSString *p = [[NSBundle mainBundle] pathForResource:@"placetypes" ofType:@"plist"];
    NSDictionary *pListContents = [NSDictionary dictionaryWithContentsOfFile:p];
    placeTypes = [pListContents allKeys];
    
    //Do the initial request
    NSString *requestUrl = [self buildRequestUrl:nil];
    NSURL *url = [NSURL URLWithString: requestUrl];
    NSMutableData *lData = [[NSMutableData alloc] initWithContentsOfURL:url];
    //NSLog(@"url: %@", url);
    
    if (lData != nil) {
        //jsonify the data
        NSDictionary *responseResult = [NSJSONSerialization JSONObjectWithData:lData
                                                                       options:kNilOptions
                                                                         error:&error] ;
        //grab the first page of places
        NSArray *results = [responseResult objectForKey:@"results"];
        //iterate through each place and grab our data
        for (int i = 0; i < results.count; i++) {
            NSArray *types = [[results objectAtIndex:i] objectForKey:@"types"];
            for (NSString *type in types) {
                if ([placeTypes containsObject:type]) {
                    //Only add supported place types
                    [placesDictionaryArray addObject:[results objectAtIndex:i]];
                    [placeNames addObject:[[results objectAtIndex:i] objectForKey:@"name"]];
                    break;
                }
            }
        }
        
        
        /******TAKE OUT TEMPORARILY**************************
         *****LET'S JUST PULL 20 PLACES FOR NOW *****************/
         
        //Do subsequent place requests based on if there is a next_page_token in the previous request
        /*
        nextPageToken = [responseResult objectForKey:@"next_page_token"];
        if (nextPageToken != nil && nextPageToken.length > 0) {
            requestUrl = [self buildRequestUrl:nextPageToken];
            url = [NSURL URLWithString:requestUrl];
            //NSLog(@"nextpage URL: %@", url);
            
            NSMutableData *lNewData = [[NSMutableData alloc] initWithContentsOfURL:url];
            
            if (lNewData != nil) {
                responseResult = [NSJSONSerialization JSONObjectWithData:lNewData
                                                                 options:kNilOptions
                                                                   error:&error];
                results = [responseResult objectForKey:@"results"];
                
                //iterate through each place and grab our data
                for (int i = 0; i < results.count; i++) {
                    NSArray *types = [[results objectAtIndex:i] objectForKey:@"types"];
                    for (NSString *type in types) {
                        if ([placeTypes containsObject:type]) {
                            //Only add supported place types
                            [placesDictionaryArray addObject:[results objectAtIndex:i]];
                            [placeNames addObject:[[results objectAtIndex:i] objectForKey:@"name"]];
                            break;
                        }
                    }
                }
                //NSLog(@"placeNames Count 2: %d", [self.placeNames count]);
                
                //There's a max of 60 places per request, so we can stop here
                NSString *newPageToken = [responseResult objectForKey:@"next_page_token"];
                if (newPageToken != nil & newPageToken.length > 0) {
                    //grab our last round of data
                    nextPageToken = newPageToken;
                    requestUrl = [self buildRequestUrl:nextPageToken];
                    url = [NSURL URLWithString:requestUrl];
                    lNewData = [NSMutableData dataWithContentsOfURL:url];
                    
                    if (lNewData != nil) {
                        responseResult = [NSJSONSerialization JSONObjectWithData:lNewData
                                                                         options:kNilOptions
                                                                           error:&error];
                        results = [responseResult objectForKey:@"results"];
                        
                        //iterate through each place and grab our data
                        for (int i = 0; i < results.count; i++) {
                            NSArray *types = [[results objectAtIndex:i] objectForKey:@"types"];
                            for (NSString *type in types) {
                                if ([placeTypes containsObject:type]) {
                                    //Only add supported place types
                                    [placesDictionaryArray addObject:[results objectAtIndex:i]];
                                    [placeNames addObject:[[results objectAtIndex:i] objectForKey:@"name"]];
                                    break;
                                }
                            }
                            
                        }
                        //NSLog(@"placeNames Count 3: %d", [self.placeNames count]);
                    }
                }
            }
        }
         */
        /*
         NSLog(@"nextpagetoken: %@", nextPageToken);
         NSLog(@"iconUrl: %@", iconUrl);
         
         NSLog(@"placeNames Count: %d", [self.placeNames count]);
         
         for (NSString *str in [self placeNames]) {
         NSLog(@"place name: %@", str);
         }
         */
        
        //NSLog(@"URL: %@", url);
        
        //Make a call to grab all the details for each place. We'll be able to link the details to
        // it's parent place by the placeId.
        for (NSMutableDictionary *item in placesDictionaryArray) {
            NSString *detailsUrl = [self buildPlaceDetailsUrl:[item objectForKey:@"reference"]];
            if (detailsUrl != nil) {
                url = [NSURL URLWithString:detailsUrl];
                NSMutableData *detailsData = [NSMutableData dataWithContentsOfURL:url];
                if (detailsData != nil) {
                    responseResult = [NSJSONSerialization JSONObjectWithData:detailsData
                                                                     options:kNilOptions
                                                                       error:&error];
                    results = [responseResult objectForKey:@"result"];
                    
                    [placeDetailsDictionaryArray addObject:results];
                }
            }
        }
        [placesInformation setPlacesDictionaryArray:placesDictionaryArray];
        [placesInformation setPlaceDetailsDictionaryArray:placeDetailsDictionaryArray];
        [placesInformation setPlaceNames:placeNames];
        
        return placesInformation;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Unable to retrieve places data. Check your device's connection and try again"
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    
    return nil;
}

- (NSString *)buildPlaceDetailsUrl:(NSString *) pReference {
    NSString *requestUrl = GOOGLE_API_BASE_PLACE_DETAILS_URL;
    if (pReference != nil && pReference.length > 0) {
        requestUrl = [requestUrl stringByAppendingString:pReference];
        requestUrl = [requestUrl stringByAppendingString:@"&sensor=true"];
        requestUrl = [requestUrl stringByAppendingString:@"&key="];
        requestUrl = [requestUrl stringByAppendingString:GOOGLE_API_SERVER_KEY];
    }
    else return nil;
    
    //NSLog(@"details url: %@", requestUrl);
    return requestUrl;
}

- (NSData *)getPlacePhotoData:(NSString *)photoReference
{
    NSString *requestUrl = [NSString stringWithFormat:GOOGLE_API_PHOTOS_URL, photoReference, GOOGLE_API_SERVER_KEY];
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSData *lData = [[NSData alloc] initWithContentsOfURL:url];
    return lData;
}

- (UIImage *)getPlacePhoto:(NSString *)photoReference
{
    NSString *requestUrl = [NSString stringWithFormat:GOOGLE_API_PHOTOS_URL, photoReference, GOOGLE_API_SERVER_KEY];
    NSURL *url = [NSURL URLWithString:requestUrl];
    //NSLog(@"PHOTO URL: %@", url);
    NSMutableData *lData = [[NSMutableData alloc] initWithContentsOfURL:url];
    UIImage *lImage = [UIImage imageWithData:lData];
    
    return lImage;
}

- (NSString *)buildRequestUrl:(NSString *)nextPageToken
{
    //TODO: uncomment below before deploying to device
    //NSError *error;
    CoreDataHelper *coreDataHelper = [[CoreDataHelper alloc] init];
    //NSArray *lSettingsResults = [coreDataHelper fetchData:SETTINGS_ENTITY];
    //SettingsData *settingsData = [lSettingsResults objectAtIndex:[lSettingsResults count] - 1];
    
    //Set the search radius
    double lRadius = 100.0f;
    
    //double newRadius = round(lRadius);
    NSArray *fetchedResults = [coreDataHelper fetchData:LOCATION_ENTITY];
    NSUInteger lSize = [fetchedResults count];
    LocationData *lLocation = [fetchedResults objectAtIndex:lSize - 1];
    //Bill's area
    //NSString *lLatitude = @"33.697333";
    //NSString *lLongitude = @"-117.740779";
    
    //Rawbar
    NSString *lLatitude = @"39.728352";
    NSString *lLongitude = @"-121.840017";
    
    //Win River - Redding, CA
    //NSString *lLatitude = @"40.507374";
    //NSString *lLongitude = @"-122.382919";
    
    //Rice Bowl - Chico, CA
    //NSString *lLatitude = @"39.761562";
    //NSString *lLongitude = @"-121.865803";
    
    //Boston
    //NSString *lLatitude = @"42.360122";
    //NSString *lLongitude = @"-71.055675";
    
    //Current location
    //double lLatitude = [[lLocation latitude]doubleValue];
    //double lLongitude = [[lLocation longitude]doubleValue];
    NSString *requestURL = GOOGLE_API_BASE_URL;
    if (nextPageToken != nil && nextPageToken.length > 0) {
        NSString *token = nextPageToken;
        requestURL = [requestURL stringByAppendingString:@"pagetoken="];
        requestURL = [requestURL stringByAppendingString:token];
        requestURL = [requestURL stringByAppendingString:@"&sensor=true"];
        requestURL = [requestURL stringByAppendingString:@"&key="];
        requestURL = [requestURL stringByAppendingString:GOOGLE_API_SERVER_KEY];
    } else {
        requestURL = [requestURL stringByAppendingString:@"location="];
        //requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"%f", lLatitude]];
        requestURL = [requestURL stringByAppendingString:lLatitude];
        requestURL = [requestURL stringByAppendingString:@","];
        //requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"%f", lLongitude]];
        requestURL = [requestURL stringByAppendingString:lLongitude];
        requestURL = [requestURL stringByAppendingString:@"&radius="];
        requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"%.0f", lRadius]];
        requestURL = [requestURL stringByAppendingFormat:@"&sensor=true"];
        requestURL = [requestURL stringByAppendingString:@"&key="];
        requestURL = [requestURL stringByAppendingString:GOOGLE_API_SERVER_KEY];
    }
    
    return requestURL;
}

@end
