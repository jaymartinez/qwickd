//
//  NearbyViewController.h
//  Qwickd
//
//  Created by Jay on 12/7/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ActivityView.h"
#import "CoreDataHelper.h"
#import "LocationHelper.h"
#import "PlacesInformation.h"
#import "PlacesHelper.h"
#import "PlaceDetails.h"


@interface NearbyViewController : UITableViewController
{
    CoreDataHelper *coreDataHelper;
    ActivityView *activityView;
    LocationHelper *locationHelper;
    NSMutableArray *_placeNames;
    PlacesHelper *placesHelper;
    UIRefreshControl *refreshControl;
}

@property (nonatomic) NSData *placesData;
@property (nonatomic) NSMutableArray *placeNames;
@property (nonatomic) NSMutableDictionary *placesDictionary;
@property (nonatomic) NSMutableArray *placesDictionaryArray;
@property (nonatomic) NSArray *placeDetails;
@property (nonatomic) NSArray *placesImages;
@property (nonatomic) PlacesInformation *placesInformation;
@property (nonatomic) NSArray *placesInformationArray;
@property (nonatomic) NSArray *myToolbarItems;

- (void)refreshTableView;

@end
