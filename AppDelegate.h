//
//  AppDelegate.h
//  Qwickd
//
//  Created by Jay on 10/14/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

//Constants

//dispatch queue names
static char* DISPATCH_QUEUE_1 = "DispatchQueue1";

//Google places base URL
static NSString *const GOOGLE_API_BASE_URL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?";

//Google places base URL for retrieving place details
static NSString *const GOOGLE_API_BASE_PLACE_DETAILS_URL = @"https://maps.googleapis.com/maps/api/place/details/json?reference=";

//Google places base URL for retrieving photos
static NSString *const GOOGLE_API_PHOTOS_URL = @"https://maps.googleapis.com/maps/api/place/photo?maxwidth=60&photoreference=%@&sensor=true&key=%@";

//Google API Key
static NSString *const GOOGLE_API_KEY = @"AIzaSyBEd3cUUSG4SvRewnCokxbitvuiIWfbjEw";
static NSString *const GOOGLE_API_SERVER_KEY = @"AIzaSyCbKUWyXAaV1Iqb0SEylr_yunkT_yJTJwI";

// NSNotification userInfo keys
static NSString *const LOCATION_KEY = @"location";
static NSString *const TIMER_KEY = @"TimerFired";
static NSString *const PLACES_KEY = @"places";

// Notification names
static NSString *const LOCATION_CHANGE_NOTIFICATION = @"LocationChangeNotification";
static NSString *const TIMER_NOTIFICATION = @"TimerFiredNotification";


/**** CoreData Constants ****/

//entity (Parse.com class) constants
static NSString *const USER_ENTITY = @"UserData";
static NSString *const LOCATION_ENTITY = @"LocationData";
static NSString *const PLACES_ENTITY = @"PlacesData";
static NSString *const SETTINGS_ENTITY = @"SettingsData";
static NSString *const PLACE_DETAILS_ENTITY = @"PlaceDetails";
static NSString *const DEFAULT_SURVEY_ENTITY = @"DefaultSurveyData";

//property constants
static NSString *const USER_USERNAME = @"username";
static NSString *const USER_ID = @"userId";
static NSString *const CURRENTLOCATION_LATITUDE = @"currentLatitude";
static NSString *const CURRENTLOCATION_LONGITUDE = @"currentLongitude";
static NSString *const CURRENTLOCATION_OLD_LONGITUDE = @"oldLongitude";
static NSString *const CURRENTLOCATION_OLD_LATITUDE = @"oldLatitude";
static NSString *const LOCATION_LATITUDE = @"latitude";
static NSString *const LOCATION_LONGITUDE = @"longitude";
static NSString *const LOCATION_RECORDED_AT = @"recordedAt";
static NSString *const PLACES_ADDRESS = @"address";
static NSString *const PLACES_NAME = @"name";
static NSString *const PLACES_PHONE_NUMBER = @"phoneNumber";
static NSString *const PLACES_ICON_URL = @"iconUrl";

//relationship constants
static NSString *const RELATIONSHIP_LOCATION = @"locationRelationship";
static NSString *const RELATIONSHIP_USER = @"userRelationship";
static NSString *const RELATIONSHIP_PLACES = @"placesRelationship";
static NSString *const RELATIONSHIP_CURRENTLOCATION = @"currentLocationRelationship";

/**** End CoreData Constants ****/

/** parse.com column constants **/
static NSString *const COL_USER = @"user";
static NSString *const COL_USERNAME = @"username";
static NSString *const COL_LOCATION = @"location";
static NSString *const COL_LOCATION_LAST = @"lastLocation";
static NSString *const COL_OBJECTID = @"objectId";
static NSString *const COL_EMAIL = @"email";
static NSString *const COL_LAST_LAT = @"lastLatitude";
static NSString *const COL_LAST_LONG = @"lastLongitude";

enum toolbarIdentifiers
{
    kHomeButton,
    kSettingsButton,
    kNearbyButton,
    kChatButton
};


#import <UIKit/UIKit.h>

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import "QWLocation.h"
#import "LocationData.h"

@class ViewController;
@class TimerHandler;
@class CoreDataHelper;
@class LocationHelper;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) PFLogInViewController *loginViewController;
@property (strong, nonatomic) FBSession *fbSession;
@property (nonatomic, strong) TimerHandler *timerHandler;
@property (nonatomic, strong) CoreDataHelper *coreDataHelper;
@property (nonatomic, strong) LocationHelper *locationHelper;


@end
