//
//  QWPlaces.m
//  Qwickd
//
//  Created by Jay on 12/9/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import "QWPlaces.h"
#import "AppDelegate.h"
#import "LocationData.h"
#import "SBJsonParser.h"
#import "CoreDataHelper.h"
#import "SettingsData.h"

@implementation QWPlaces


@synthesize coreDataHelper = _coreDataHelper;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (CoreDataHelper *)coreDataHelper {
    if (_coreDataHelper != nil) {
        return _coreDataHelper;
    }
    
    _coreDataHelper = [[CoreDataHelper alloc] init];
    return _coreDataHelper;
}

- (NSMutableArray *)fetchPlaces {
    
    //Do the initial request
    NSString *requestUrl = [self buildRequestUrl];
    NSURL *url = [NSURL URLWithString: requestUrl];
    NSMutableData *lData = [[NSMutableData alloc] initWithContentsOfURL:url];
    NSError *error;
    NSLog(@"url: %@", url);
    
    if (lData != nil) {
        //jsonify the data
        NSDictionary *responseResult = [NSJSONSerialization JSONObjectWithData:lData
                                                                       options:kNilOptions
                                                                         error:&error] ;
        
        self.placesDictionaryArray = [[NSMutableArray alloc] init];
        self.placeDetailsDictionaryArray = [[NSMutableArray alloc] init];
        self.placesDictionary = [[NSMutableDictionary alloc] init];
        self.placeNames = [[NSMutableArray alloc] init];
        
        //grab the first page of places
        NSArray *results = [responseResult objectForKey:@"results"];
        //iterate through each place and grab our data
        for (int i = 0; i < results.count; i++) {
            [self.placesDictionaryArray addObject:[results objectAtIndex:i]];
            [self.placeNames addObject:[[results objectAtIndex:i] objectForKey:@"name"]];
        }
        
        //NSLog(@"placeNames Count 1: %d", [self.placeNames count]);
        
        //Do subsequent place requests based on if there is a next_page_token in the previous request
        nextPageToken = [responseResult objectForKey:@"next_page_token"];
        if (nextPageToken != nil && nextPageToken.length > 0) {
            requestUrl = [self buildRequestUrl];
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
                    [self.placesDictionaryArray addObject:[results objectAtIndex:i]];
                    [self.placeNames addObject:[[results objectAtIndex:i] objectForKey:@"name"]];
                }
                //NSLog(@"placeNames Count 2: %d", [self.placeNames count]);
                
                //There's a max of 60 places per request, so we can stop here
                NSString *newPageToken = [responseResult objectForKey:@"next_page_token"];
                if (newPageToken != nil & newPageToken.length > 0) {
                    //grab our last round of data
                    nextPageToken = newPageToken;
                    requestUrl = [self buildRequestUrl];
                    url = [NSURL URLWithString:requestUrl];
                    lNewData = [NSMutableData dataWithContentsOfURL:url];
                    
                    if (lNewData != nil) {
                        responseResult = [NSJSONSerialization JSONObjectWithData:lNewData
                                                                         options:kNilOptions
                                                                           error:&error];
                        results = [responseResult objectForKey:@"results"];
                        
                        //iterate through each place and grab our data
                        for (int i = 0; i < results.count; i++) {
                            [self.placesDictionaryArray addObject:[results objectAtIndex:i]];
                            [self.placeNames addObject:[[results objectAtIndex:i] objectForKey:@"name"]];
                        }
                        //NSLog(@"placeNames Count 3: %d", [self.placeNames count]);
                    }
                }
            }
        }
        /*
        NSLog(@"nextpagetoken: %@", nextPageToken);
        NSLog(@"iconUrl: %@", iconUrl);
        NSLog(@"URL: %@", url);
        NSLog(@"placeNames Count: %d", [self.placeNames count]);
        
        for (NSString *str in [self placeNames]) {
            NSLog(@"place name: %@", str);
        }
         */
        
        for (NSMutableDictionary *item in self.placesDictionaryArray) {
            NSString *detailsUrl = [self buildPlaceDetailsUrl:[item objectForKey:@"reference"]];
            if (detailsUrl != nil) {
                url = [NSURL URLWithString:detailsUrl];
                NSMutableData *detailsData = [NSMutableData dataWithContentsOfURL:url];
                if (detailsData != nil) {
                    responseResult = [NSJSONSerialization JSONObjectWithData:detailsData
                                                                     options:kNilOptions
                                                                       error:&error];
                    results = [responseResult objectForKey:@"result"];
                    [[self placeDetailsDictionaryArray] addObject:results];
                }
            }
        }
        
        return placesDictionaryArray;
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

- (NSString *)buildRequestUrl
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:LOCATION_ENTITY
                                                      inManagedObjectContext:[self.coreDataHelper context]];
    [fetchRequest setEntity:locationEntity];
    //TODO: uncomment below before deploying to device
    //NSError *error;
    CoreDataHelper *coreDataHelper = [[CoreDataHelper alloc] init];
    NSArray *lSettingsResults = [coreDataHelper fetchData:SETTINGS_ENTITY];
    SettingsData *settingsData = [lSettingsResults objectAtIndex:[lSettingsResults count] - 1];
    double lRadius = settingsData.searchRadius.doubleValue;
    double newRadius = round(lRadius);
    //NSArray *fetchedResults = [helper fetchData:LOCATION_ENTITY];
    //int lSize = [fetchedResults count];
    //LocationData *lLocation = [fetchedResults objectAtIndex:lSize - 1];
    NSString *lLatitude = @"39.768052";
    //double lLatitude = [[lLocation latitude]doubleValue];
    NSString *lLongitude = @"-121.842569";
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
        requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"%.0f", newRadius]];
        requestURL = [requestURL stringByAppendingFormat:@"&sensor=true"];
        requestURL = [requestURL stringByAppendingString:@"&key="];
        requestURL = [requestURL stringByAppendingString:GOOGLE_API_SERVER_KEY];
    }
    
    return requestURL;
}
@end
